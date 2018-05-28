{ config, lib, pkgs, ... }:
let
  kernelConfig = import ./config.nix;
in {
  nixpkgs.overlays = [( self: super: {
    firmwareLinuxNonfree = with super; firmwareLinuxNonfree.overrideAttrs(old: rec {
      src = fetchgit {
        url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
        rev = "397a604e081fa4a7a65f31b75494f80f1e1d9e09";
        sha256 = "11p5z1jpb1nrw2i7aj6310ahs0r88xyvsp0pz62s5hrzxawv2hda";
      }; 
    });

    linux_testing_plumelo = super.callPackage <nixos/pkgs/os-specific/linux/kernel/linux-testing.nix> {
      kernelPatches = with super; [ 
        kernelPatches.bridge_stp_helper 
        kernelPatches.modinst_arg_list_too_long 
      ];
      argsOverride = with super; rec {
        version = "4.17-rc6";
        modDirVersion = "4.17.0-rc6";
        src = fetchurl {
          url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
          sha256 = "16x8bwhaj35fqhl773qxwabs1rhl3ayapizjsqyzn92pggsgy6p8";
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
        KALLSYMS_ALL y
        CPU_SUP_CENTAUR n
        MK8 n
        MPSC n
        MATOM n
        CC_OPTIMIZE_FOR_PERFORMANCE y
        DRM_NOUVEAU n 
        DRM_I915 n 
        DRM_RADEON n
        NR_CPUS 4 
        BT n  
        DRM_AMD_DC y
        DRM_AMD_DC_DCN1_0 y
        ${exclude.uncommon}
        ${exclude.fs}
        ${exclude.net}
        ${exclude.wlan}
      '';
    });

    linux_testing_yoga2pro = with kernelConfig; self.linux_testing_plumelo.override({
      ignoreConfigErrors= true;
      extraConfig =''
        CPU_SUP_AMD n
        CPU_SUP_CENTAUR n
        CC_OPTIMIZE_FOR_PERFORMANCE y
        NR_CPUS 8
        MCORE2 y
        MK8 n
        MPSC n
        MATOM n
        BT n
        DRM_NOUVEAU n
        DRM_RADEON n
        DRM_AMDGPU n
        ${exclude.uncommon}
        ${exclude.fs}
        ${exclude.net}
        ${exclude.wlan}
      '';
    });

    linux_4_17           = self.linuxPackages_testing; 
    linux_4_17_slim      = super.linuxPackagesFor self.linux_testing_slim;
    linux_4_17_gag3wifi  = super.linuxPackagesFor self.linux_testing_gag3wifi;
    linux_4_17_yoga2pro  = super.linuxPackagesFor self.linux_testing_yoga2pro;
  })];
}
