{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.nouun;
in {
  options.nouun = {
    timeZone = mkOption {
      description = "The time zone used when displaying times and dates.";
      type = types.str;
      default = "Pacific/Auckland";
    };
  };

  config = {
    time.timeZone = cfg.timeZone;
  };
}
