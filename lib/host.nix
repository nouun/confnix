{ system, pkgs, home-manager, lib, user, ... }:
with builtins;
{
  mkHost = { name, NICs, fileSystems, initrdMods, kernelMods, kernelParams, kernelPackage, extraKernelPackages ? [], cpuCores, systemConfig, users, wifi ? [] }:
  let
    networkCfg = listToAttrs (map (NIC: {
      name = "${NIC}";
      value = {
        useDHCP = true;
      };
    }) NICs);

    userCfg = {
      inherit name NICs systemConfig;
    };

    sysUsers = (map (u: user.mkSystemUser u) users);
  in lib.nixosSystem {
    inherit system;

    modules = [
      {
        imports = [ ../modules/system ] ++ sysUsers;

        nouun = systemConfig;

        environment = {
          etc = {
            "hmsystemdata.json".text = toJSON userCfg;
          };

          systemPackages = with pkgs; [
            vim
          ];
        };

        networking = {
          hostName = "${name}";
          interfaces = networkCfg;
          wireless.interfaces = wifi;

          networkmanager.enable = true;
          useDHCP = false;
        };

        boot = {
          initrd.availableKernelModules = initrdMods;
          kernelModules = kernelMods;
          kernelParams = kernelParams;
          kernelPackages = kernelPackage;
          extraModulePackages = extraKernelPackages;
        };

        fileSystems = fileSystems;

        console.font = "Lat2-Terminus16";
        hardware.cpu.intel.updateMicrocode = true;

        nixpkgs.pkgs = pkgs;
        nix = {
          settings.max-jobs = lib.mkDefault cpuCores;
          
          package = pkgs.nixUnstable;
          extraOptions = ''
            experimental-features = nix-command flakes
          '';
        };

        services = {
          xserver = {
            enable = true;

            libinput = {
              enable = true;

              touchpad = {
                tapping = true;
                naturalScrolling = true;
              };
            };

            videoDrivers = [ "modesetting" ];
          };
        };

        system.stateVersion = "21.11";
      }
    ];
  };
}
