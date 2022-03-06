{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.nouun;
in {
  options.nouun.pkgs = mkOption {
    description = "Extra user packages";
    type = types.listOf types.package;
    default = true;
  };

  config = {
    home.packages = cfg.pkgs;
  };
}
