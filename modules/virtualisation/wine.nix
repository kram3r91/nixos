{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wineStaging
  ];
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;
}
