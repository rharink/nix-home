{ config, lib, pkgs, ... }:

{
  programs.ssh.startAgent = false;
  services.pcscd.enable = true;

  environment.systemPackages = with pkgs; [
    gnupg
    yubikey-personalization
  ];

  services.udev.packages = with pkgs; [
    yubikey-personalization
  ];
}
