{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.nouun.git;
in {
  options.nouun.git = {
    enable = mkOption {
      description = "Enable git";
      type = types.bool;
      default = true;
    };

    userName = mkOption {
      description = "Name for git";
      type = types.str;
    };

    userEmail = mkOption {
      description = "Email for git";
      type = types.str;
    };
  };

  config = mkIf (cfg.enable) {
    programs.git = {
      enable = true;
      userName = cfg.userName;
      userEmail = cfg.userEmail;
      extraConfig = {
        credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";
      };
    };
  };
}
