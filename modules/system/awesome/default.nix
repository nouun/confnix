{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.nouun.awesome;
in {
  options.nouun.awesome = {
    enable = mkOption {
      description = "Enable AwesomeWM";
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
    services.xserver = {
      enable = true;

      displayManager.defaultSession =
        mkIf (cfg.defaultSession) "none+awesome";

      windowManager.awesome = {
        enable = true;

        package = cfg.pkg;
        luaModules =  with pkgs.lua52Packages; [
          luarocks
          lgi
        ];
      };
    };
  };
}
