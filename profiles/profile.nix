{ config, lib, pkgs, ... }:
{
  imports = [
    ./local.nix
    ./plumelo.nix
    ../modules/services/X11/gnome3.nix 
  ];
  boot = {
    kernelModules = [
      "it87"
    ];
    extraModulePackages  = [pkgs.it87];
    kernelPackages = pkgs.linux_4_17_gag3wifi;
  }; 
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.enableAllFirmware = true;
  environment.etc = with pkgs; {
    "amdpgu/raven_ce.bin".source = firmwareLinuxNonfree + "/amdpgu/raven_ce.bin";
    "amdpgu/raven_gpu_info.bin".source = firmwareLinuxNonfree + "/amdpgu/raven_gpu_info.bin";
  };
}
