{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.nouun.neovim;
in {
  options.nouun.neovim = {
    enable = mkOption {
      description = "Enable Neovim";
      type = types.bool;
      default = false;
    };

    pkg = mkOption {
      description = "Neovim package";
      type = types.package;
      default = pkgs.neovim-unwrapped;
    };

    extraPkgs = mkOption {
      description = "Extra packages";
      type = types.listOf types.package;
      default = [];
    };
  };

  config = mkIf (cfg.enable) {
    programs.neovim = {
      enable = true;
      package = cfg.pkg;
    };

    home.packages = cfg.extraPkgs;
  };
}
