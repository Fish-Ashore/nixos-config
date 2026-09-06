# 引导加载器与 GRUB 主题。
{ ... }:

{
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      # 内核不继承 GRUB 的图形画面，避免进入系统后主题背景残影残留
      # gfxpayloadEfi = "text";
      # 选中启动项瞬间即清屏并切到无壁纸的 console 终端，
      # 让主题背景与菜单元素同时消失，而不是定格约 1 秒等内核接管
      extraPerEntryConfig = ''
        clear
        terminal_output console
        clear
      '';
    };
    elegant-grub2-theme = {
      enable = true;
      theme = "mojave";
      type = "blur";
      side = "left";
      color = "dark";
      screen = "1080p";
      logo = "system";
    };
  };
}
