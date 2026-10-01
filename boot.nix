# 引导加载器与 GRUB 主题。
{ ... }:

{
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      # 关闭 os-prober：Windows 所在的 Kingston OM8SEP4512Q(无 DRAM) 会偶发从
      # PCIe 总线掉线，内核日志为
      #   nvme nvme0: Disabling device after reset failure: -19
      #   nvme nvme0: Identify namespace failed (-5)
      # 每次 nixos-rebuild 时扫描该盘都会触发掉线，os-prober 读到 I/O error，
      # 于是生成的 grub.cfg 里没有 Windows 项。改为按 ESP 的 UUID 写死 chainloader。
      useOSProber = false;
      extraEntries = ''
        menuentry "Windows Boot Manager" --class windows --class os {
          insmod part_gpt
          insmod fat
          insmod chain
          search --no-floppy --fs-uuid --set=root EC11-4868
          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }
      '';
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
