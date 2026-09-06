# Home Manager 用户配置与个人软件包。
{ inputs, pkgs, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users."hy" = {
      home = {
        stateVersion = "26.05";
        packages = with pkgs; [
          google-chrome
          firefox
          zed-editor-fhs
          nautilus
          alacritty
          fuzzel
          inputs.mark-shot.packages.${pkgs.stdenv.hostPlatform.system}.default
          mako
          orchis-theme
          papirus-icon-theme

          cliphist
          wl-clipboard # cliphist 依赖这个来操作剪贴板

          # Electron 43.4.1 托盘 SNI 注册被 Chromium 回归弄坏（electron/electron#53213，
          # 其 RegisterStatusNotifierItem 参数带路径，waybar 等 watcher 会拒绝），
          # Wayland 下无 XEmbed 兜底，托盘因此无图标；退回 Electron 42 恢复。
          (splayer-next.override { electron_43 = electron_42; })
          bilibili
          # 系统监视器
          # inputs.rproc.packages.${pkgs.stdenv.hostPlatform.system}.default
          inputs.tuxManager.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];
      };

      services.cliphist = {
        enable = true;
        systemdTargets = [ "graphical-session.target" ]; # 随图形界面启动
        allowImages = true; # 记录图片
      };

      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme = "Orchis-Dark";
          icon-theme = "Papirus-Dark";
        };
      };

      gtk = {
        enable = true;

        theme = {
          package = pkgs.orchis-theme;
          name = "Orchis-Dark";
        };

        iconTheme = {
          package = pkgs.papirus-icon-theme;
          name = "Papirus-Dark";
        };

        # GTK3 优先暗色；GTK4/libadwaita 请勿设置 gtk-application-prefer-dark-theme，
        # 该键已被 libadwaita 弃用（每次启动都报警告），暗色由 color-scheme 决定。
        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };
      };
    };
  };
}
