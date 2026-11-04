# 杂项程序 / 服务：Shell、Seahorse、AppImage、Flatpak。
{ pkgs, ... }:

{
  programs.fish.enable = true;
  programs.seahorse.enable = true;

  programs.appimage = {
    enable = true;
    binfmt = true;

    # 关键：在 appimage-run 的沙箱环境中加入 libseccomp
    package = pkgs.appimage-run.override {
      extraPkgs =
        pkgs: with pkgs; [
          libseccomp
          libselinux
          acl
          libgudev
        ];
    };
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
