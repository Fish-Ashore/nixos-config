# 系统级软件包与字体。
# 个人使用的软件包请放到 home.nix 的 home.packages 中。
{ pkgs, pkgsStable, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    vim
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
    libsForQt5.qt5ct
    wechat
    qq
    btop
    wpsoffice-cn
    jetbrains.idea
    jetbrains.pycharm
    jetbrains.clion
    jetbrains.datagrip
    android-studio

    python314
    uv
    jdk25
    jdt-language-server
    gcc
    gdb
    nodejs
    pnpm
    eslint
    go
    maven
    kotlin
    gradle
    # 提供 org.gnome.desktop.* 等 gsettings 架构。必须放系统级才会进入
    # /run/current-system/sw/share/gsettings-schemas（XDG_DATA_DIRS 默认包含），
    # 否则 GTK 应用读不到 gtk-theme / color-scheme / icon-theme，主题不生效。
    glib
    gsettings-desktop-schemas
    pkgsStable.flclash # 仅 26.05 有，unstable 已移除
    ntfs3g
    fzf
  ];

  # 1. 安装中文字体包
   fonts.packages = with pkgs; [
     noto-fonts-cjk-sans     # 思源黑体，推荐的无衬线中文字体
     noto-fonts-cjk-serif    # 思源宋体，推荐的衬线中文字体
     wqy_zenhei              # 文泉驿正黑，经典的无衬线中文字体
     noto-fonts-color-emoji  # Emoji 支持
     nerd-fonts._0xproto
     # pkgs.nur.repos.rewine.ttf-wps-fonts
     nerd-fonts.jetbrains-mono
     lxgw-wenkai
   ];

   # 2. 配置 Fontconfig 默认字体
   fonts.fontconfig = {
     enable = true; # 确保 fontconfig 服务已启用

     defaultFonts = {
       # 无衬线字体族：中文字体放在英文字体之后作为回退
       sansSerif = [ "Noto Sans" "Noto Sans CJK SC" "WenQuanYi Zen Hei" ];
       # 衬线字体族
       serif = [ "Noto Serif" "Noto Serif CJK SC" ];
       # 等宽字体族
       monospace = [ "Fira Code" "Noto Sans Mono CJK SC" ];
       # Emoji 字体
       emoji = [ "Noto Color Emoji" ];
     };
   };
}
