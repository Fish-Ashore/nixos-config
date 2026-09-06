# 硬件相关：显卡驱动 / 蓝牙 / 移动存储。
{ config, ... }:

{
  # 启用 OpenGL
  hardware.graphics.enable = true;

  # 在 Xorg 和 Wayland 中加载 nvidia 驱动
  services.xserver.videoDrivers = [
    "nvidia"
    "modesetting"
  ];

  hardware.nvidia = {
    modesetting.enable = true; # Wayland 需要
    open = true; # 使用开源内核模块

    prime = {
      # 启用 PRIME 卸载功能
      offload.enable = true;
      # 启用 nvidia-offload 命令
      offload.enableOffloadCmd = true;

      # 请确保以下 Bus ID 正确无误
      intelBusId = "PCI:0:2:0"; # 集成显卡
      nvidiaBusId = "PCI:1:0:0"; # NVIDIA 独显
    };
    nvidiaSettings = true; # 启用 NVIDIA 控制面板
    package = config.boot.kernelPackages.nvidiaPackages.stable; # 使用稳定版驱动
  };

  # 蓝牙
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # 移动存储自动挂载
  services.udisks2.enable = true;
  services.devmon.enable = true;
}
