{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.nouun.picom;

  shadowModule = types.submodule {
    options = {
      enable = mkOption {
        description = "Enable shadows";
        type = types.bool;
        default = false;
      };

      exclude = mkOption {
        description = "List of conditions of windows that should have no shadow";
        type = types.listOf types.str;
        default = [];
      };

      opacity = mkOption {
        description = "Shadow opacity. (Between 0.00 and 1.00)";
        type = types.str;
        default = "0.75";
      };

      offset.x = mkOption {
        description = "Horizontal offset for shadows in pixels.";
        type = types.int;
        default = -15;
      };

      offset.y = mkOption {
        description = "Vertical offset for shadows in pixels.";
        type = types.int;
        default = -15;
      };
    };
  };
in {
  options.nouun.picom = {
    enable = mkOption {
      description = "Enable picom compositor";
      type = types.bool;
      default = true;
    };

    shadow = mkOption {
      description = "Draw window shadows";
      type = shadowModule;
      default = { };
    };
  };

  config = mkIf (cfg.enable) {
    services.picom = {
      enable = true;
      experimentalBackends = true;

      shadow = cfg.shadow.enable;
      shadowOpacity = cfg.shadow.opacity;
      shadowOffsets = [
        cfg.shadow.offset.x
        cfg.shadow.offset.y
      ];
      shadowExclude = cfg.shadow.exclude;
    };
  };
}
