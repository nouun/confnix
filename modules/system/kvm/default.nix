{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.nouun.kvm;
in {
  options.nouun.kvm = {
    enable = mkOption {
      description = "Enable KVM";
      type = types.bool;
      default = false;
    };

    pkg = mkOption {
      description = "Awesome package";
      type = types.package;
      default = pkgs.awesome;
    };

    defaultSession = mkOption {
      description = "Set Awesome as the default session";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    virtualisation.libvirtd.enable = true;

    environment.systemPackages = with pkgs; [
      virt-manager qemu_kvm
    ];
  };
}
