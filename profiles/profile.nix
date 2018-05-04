{ config, lib, pkgs, ... }:
{
  imports = [
    ./local.nix
    ./plumelo.nix
    ../modules/services/X11/kde.nix 
  ];
  boot = {
    kernelModules = [
      "it87"
    ];
    extraModulePackages  = [pkgs.it87];
    kernelPackages = pkgs.linux_4_17_gag3wifi;
  }; 
  services.xserver.videoDrivers = [ "amdgpu" ];
}
