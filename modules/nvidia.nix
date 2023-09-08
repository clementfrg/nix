{ config
, pkgs
, ...
}: {
  environment.systemPackages = [ pkgs.cudatoolkit ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    # use stable drivers
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    # required for wayland
    powerManagement.enable = true;
  };

  systemd.services.nvidia-control-devices = {
    serviceConfig.ExecStart = "${pkgs.linuxPackages.nvidia_x11.bin}/bin/nvidia-smi";
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
