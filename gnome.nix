{ pkgs, ... }:
{

  # 启用 GNOME 桌面环境
  services.desktopManager.gnome.enable = true;

  # 禁用 GNOME 核心应用套件（如浏览器、邮件等）
  services.gnome.core-apps.enable = false;

  # 禁用 GNOME 开发者工具
  services.gnome.core-developer-tools.enable = false;

  # 禁用 GNOME 游戏
  services.gnome.games.enable = false;

  # 额外排除一些非核心但常默认安装的包
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour # 欢迎向导
    gnome-user-docs # 用户文档
  ];

  environment.systemPackages = with pkgs; [
    gnome-tweaks
  ];
}
