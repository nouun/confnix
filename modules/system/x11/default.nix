{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.nouun.x11;
in {
  options.nouun.x11 = {
    enable = mkOption {
      description = "Enable x11";
      type = types.bool;
      default = false;
    };

    defaultSession = mkOption {
      description = "Default session";
      type = types.nullOr types.str;
      default = null;
    };

    libinput.enable = mkOption {
      description = "Enable libinput";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    services.xserver = {
      enable = true;
      displayManager = {
        defaultSession = mkIf (cfg.defaultSession != null) cfg.defaultSession;
      };
      libinput.enable = cfg.libinput.enable;
    };
  };
}
