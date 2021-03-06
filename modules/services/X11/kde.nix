{ config, lib, pkgs, ... }:
{

  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "eurosign:e";

    displayManager.sddm.enable = true;
    desktopManager = {
      plasma5.enable = true;
    };
  };

  programs.ssh.startAgent = true;
}
