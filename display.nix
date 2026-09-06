# 显示与桌面：键盘布局 / 显示管理器 / 音频 / 窗口管理器与桌面程序。
{ ... }:

{
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  security.pam.services.sddm.enableGnomeKeyring = true;

  # 音频（PipeWire）
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # 桌面程序
  programs.niri.enable = true;
  programs.waybar.enable = true;
  programs.hyprlock.enable = true;
  security.pam.services.hyprlock = { };
}
