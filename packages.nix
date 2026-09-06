# 系统级软件包与字体。
# 个人使用的软件包请放到 home.nix 的 home.packages 中。
{ pkgs, pkgsStable, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    vim
    awww
    ffmpeg
    libva
    libva-utils
    curl
    wget
    starship
    file-roller
    p7zip
    unrar
    unzip
    brightnessctl
    opencode
    nixd
    nil
    pciutils
    mesa-demos
    xwayland-satellite
    wechat
    qq
    btop
    wpsoffice-cn
    jetbrains.idea
    jetbrains.pycharm
    jetbrains.clion
    jetbrains.datagrip
    python314
    uv
    jdk25
    gcc
    gdb
    nodejs
    go

    # 提供 org.gnome.desktop.* 等 gsettings 架构。必须放系统级才会进入
    # /run/current-system/sw/share/gsettings-schemas（XDG_DATA_DIRS 默认包含），
    # 否则 GTK 应用读不到 gtk-theme / color-scheme / icon-theme，主题不生效。
    glib
    gsettings-desktop-schemas
    # clash-verge-rev
    pkgsStable.flclash # 仅 26.05 有，unstable 已移除
  ];

  fonts.packages = with pkgs; [
    nerd-fonts._0xproto
    pkgs.nur.repos.rewine.ttf-wps-fonts
    nerd-fonts.jetbrains-mono
  ];
}
