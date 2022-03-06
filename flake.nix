{
  description = "Nouun's system configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust.url = "github:oxalica/rust-overlay";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
  let
    inherit (nixpkgs) lib;

    util = import ./lib {
      inherit system pkgs home-manager lib; overlays = (pkgs.overlays);
    };

    inherit (util) user host;

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = with inputs; [
        (self: _:
          let system = self.system;
          in (with nixpkgs-f2k.packages.${system}; {
            awesome-git = awesome-git;
          }))

        (self: super: {
          nix-direnv = super.nix-direnv.override {
           enableFlakes = true;
          };
        })

        rust.overlay
        neovim-nightly.overlay
      ];
    };

    system = "x86_64-linux";
  in {
    homeManagerConfigurations = {
      nouun = user.mkUser {
        username = "nouun";
        userConfig = {
          pkgs = with pkgs; [
            # Basic lisps
            gerbil
            babashka
            fennel
            lua

            # General programs
            wezterm

            # Global rust shit
            rustc
            cargo
          ];

          git = {
            enable = true;
            userName = "nouun";
            userEmail = "me@nouun.dev";
          };

          neovim = {
            enable = true;
            pkg = pkgs.neovim-nightly;
            extraPkgs = with pkgs; [
              # Required for treesitter
              gcc 

              # General LSp shit
              rnix-lsp
              codespell
            ];
          };

          picom = {
            enable = true;

            shadow = {
              enable = true;

              opacity = "0.40";
              offset.x = -15;
              offset.y = -15;

              exclude = [];
            };
          };
        };
      };
    };

    nixosConfigurations = {
      "mbp" = host.mkHost {
        name = "NixBook";
        NICs = [ "enp1s0f0" ];

        systemConfig = {
          systemd-boot.enable = true;

          x11.libinput.enable = true;
          awesome = {
            enable = true;
            pkg = pkgs.awesome-git;
            defaultSession = true;
          };

          timeZone = "Pacific/Auckland";

          udev.qmk.enable = true;

          kvm.enable = true;
        };

        cpuCores = 4;

        # Kernel
        kernelPackage = pkgs.linuxPackages;
        extraKernelPackages = [ pkgs.linuxPackages.broadcom_sta ];
        initrdMods = [
          "xhci_pci" "ehci_pci" "ahci" "firewire_ohci" "usbhid"
          "usb_storage" "sd_mod" "sr_mod" "sdhci_pci"
        ];
        kernelMods = [ "kvm-intel" "wl" ];
        kernelParams = [];

        fileSystems = {
          "/" = {
            device = "/dev/disk/by-uuid/9e18945f-3d89-4893-96c8-820d403261c7";
            fsType = "ext4";
          };

          "/home" = {
            device = "/dev/disk/by-uuid/075fe08c-137f-4baa-8245-d8c0b35581a1";
            fsType = "ext4";
          };

          "/boot" = {
            device = "/dev/disk/by-uuid/A23F-3C5F";
            fsType = "vfat";
          };
        };

        users = [
          {
            name = "nouun";
            groups = [
              "adbusers" "audio" "dialout" "libvirtd"
              "networkmanager" "plugdev" "tty" "video" "wheel"
            ];
            uid = 1000;
            shell = pkgs.zsh;
          }
        ];
      };
    };
  };
}
