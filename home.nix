# Home Manager 用户配置与个人软件包。
{
  inputs,
  pkgs,
  ...
}:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    # 让 HM 用户模块（如 rproc.nix）也能拿到 flake inputs。
    extraSpecialArgs = { inherit inputs; };

    users."hy" = {
      imports = [ ./rproc.nix ];
      home = {
        stateVersion = "26.05";
        packages = with pkgs; [
          google-chrome
          firefox
          zed-editor-fhs
          vscodium-fhs
          sublime4
          nautilus
          alacritty
          inputs.mark-shot.packages.${pkgs.stdenv.hostPlatform.system}.default
          orchis-theme
          papirus-icon-theme
          wl-clipboard # 命令行剪贴板工具（wl-copy / wl-paste）
          splayer-next
          bilibili
          # nixpkgs 默认的 Electron 43.8.3 会让 Obsidian 显示空白窗口，
          # 暂时固定到 Electron 42（见 NixOS/nixpkgs#578970）。
          (pkgs.obsidian.override { electron = pkgs.electron_42; })
          obs-studio
          mpv
          fastfetch
          noctalia
          qbittorrent
          evtest
          nomacs
          pluma
          tesseract
          postman
          android-tools
          ghostty
          scrcpy
        ];
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
