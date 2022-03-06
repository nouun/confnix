{ pkgs, home-manager, lib, system, overlays, ... }:
with builtins;
{
  mkUser = { username, userConfig }:
    home-manager.lib.homeManagerConfiguration {
      inherit system username pkgs;
      stateVersion = "21.11";
      configuration =
        let
          trySettings = tryEval (fromJSON (readFile /etc/hmsystemdata.json));
          machineData = /*if trySettings.success then trySettings.value else*/ {};

          machineModule = { pkgs, config, lib, ...}: {
            options.machineData = lib.mkOption {
              default = {};
              description = "Settings passed from nixos system configuration. If not present will be empty";
            };

            config.machineData = machineData;
          };
        in {
          nouun = userConfig;
          
          nixpkgs = {
            overlays = overlays;
            config.allowUnfree = true;
          };

          systemd.user.startServices = true;
          home = {
            username = username;
            homeDirectory = "/home/${username}";

            stateVersion = "21.11";
          };

          imports = [ ../modules/users machineData ];
        };

      homeDirectory = "/home/${username}";
    };

  mkSystemUser = { name, hashedPassword ? null, groups, uid, shell, ... }:
  {
    users.users."${name}" = {
      name = name;
      isNormalUser = true;
      isSystemUser = false;
      extraGroups = groups;
      uid = uid;
      hashedPassword = hashedPassword;
      shell = shell;
    };
  };
}
