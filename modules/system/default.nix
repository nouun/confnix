{ pkgs, config, lib, ... }:
{
  imports = [
    ./misc

    ./awesome
    ./kvm
    ./systemd-boot
    ./udev
    ./x11
  ];
}
