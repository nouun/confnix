{ pkgs, config, lib, ... }:
{
  imports = [
    ./misc

    ./awesome
    ./git
    ./neovim
    ./picom
  ];
}
