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

    startPkg = mkOption {
      description = "Start package";
      type = types.nullOr types.package;
      default = null;
    };
  };

  config = mkIf (cfg.enable) {
    xsession = {
      enable = true;

      windowManager.awesome = {
        enable = true;
        package = cfg.pkg;

        luaModules = with pkgs.lua52Packages; [
          luarocks
          lgi
        ];
      };
    };

    home.packages = mkIf (cfg.startPkg != null) [ cfg.startPkg ];
  };
}
