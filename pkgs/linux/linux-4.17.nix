{ config, lib, pkgs, ... }:
let
  kernelConfig = import ./config.nix;
in {
  nixpkgs.overlays = [( self: super: {
    linux_testing_plumelo = super.callPackage <nixos/pkgs/os-specific/linux/kernel/linux-testing.nix> {
      kernelPatches = with super; [ 
        kernelPatches.bridge_stp_helper 
        kernelPatches.modinst_arg_list_too_long 
      ];
      argsOverride = with super; rec {
        version = "4.17-rc3";
        modDirVersion = "4.17.0-rc3";
        src = fetchurl {
          url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
          sha256 = "1divgjzmpl98b5j416vhkq53li0y9v5vvdwbgwpr2xznspzbkygq";
        };
      };
    };

    linux_testing_slim = with kernelConfig; super.linux_testing.override({
      ignoreConfigErrors= true;
      extraConfig =''
        CPU_SUP_CENTAUR n
        MK8 n
        MPSC n
        MATOM n
        CC_OPTIMIZE_FOR_PERFORMANCE y
        ${exclude.uncommon}
        ${exclude.fs}
        ${exclude.net}
        ${exclude.wlan}
      '';
    });

    linux_testing_gag3wifi = with kernelConfig; self.linux_testing_plumelo.override({
      ignoreConfigErrors= true;
      extraConfig =''
        CPU_SUP_CENTAUR n
        MK8 n
        MPSC n
        MATOM n
        CC_OPTIMIZE_FOR_PERFORMANCE y
        DRM_NOUVEAU n 
        DRM_I915 n 
        DRM_RADEON n
        DRM_AMDGPU_SI y
        DRM_AMDGPU_CIK y
        DRM_AMD_DC_PRE_VEGA y
        NR_CPUS 16 
        BT n  
        ${exclude.uncommon}
        ${exclude.fs}
        ${exclude.net}
        ${exclude.wlan}
      '';
    });

    linux_4_17           = self.linuxPackages_testing; 
    linux_4_17_slim      = super.linuxPackagesFor self.linux_testing_slim;
    linux_4_17_gag3wifi  = super.linuxPackagesFor self.linux_testing_gag3wifi;
  })];
}
