# 杂项程序 / 服务：Shell、Seahorse、AppImage、Flatpak。
{ pkgs, ... }:

{
  programs.fish.enable = true;
  programs.seahorse.enable = true;

  programs.appimage = {
    enable = true;
    binfmt = true; # 让系统能直接识别 AppImage
  };

  # Flatpak
  services.flatpak.enable = true;

  # 首次启用时添加 Flathub 源
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };
}
