{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.nouun.systemd-boot;
in {
  options.nouun.systemd-boot = {
    enable = mkOption {
      description = "Enable Systemd boot";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
