{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.nouun.udev;
in {
  options.nouun.udev = {
    qmk.enable = mkOption {
      description = "Enable QMK udev rules";
      type = types.bool;
      default = false;
    };
  };

  config = {
    services.udev.packages =
      (if cfg.qmk.enable then [ pkgs.qmk-udev-rules ] else []);
  };
}
