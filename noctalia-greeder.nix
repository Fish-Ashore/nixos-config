{ pkgs, ... }:

let
  avatar = ./assets/avatar.jpg;
  # tmpfiles 的 f+ 会把 argument 直接写成文件内容，所以这里用字符串而非 store 路径。
  accountsserviceUserConfig = ''
    [User]
    Icon=/var/lib/AccountsService/icons/hy
  '';
in
{
  security.pam.services.greetd.enableGnomeKeyring = true;

  services.displayManager.noctalia-greeter = {
    enable = true;

    # 允许 hy 免密把 Noctalia 的外观同步到登录界面。
    # 不设的话每次同步都要 Polkit 管理员认证，而 niri 当前没跑认证代理。
    passwordlessSyncUsers = [ "hy" ];

    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
    };

    # 通过 settings 配置 greeter.toml 中的选项
    settings = {
      # 设置默认会话和用户
      session.default = "niri"; # 你的桌面会话名称
      user.default = "hy"; # 可选，预设默认用户
      cursor.size = 24;
      keyboard.layout = "us";
      appearance = {
        scheme = "Synced";
        password_style = "random";
        hide_logo = true;
        power_buttons_position = "bottom-left";
        corner_radius_scale = 0.5;
        font_family = "JetBrains Mono Nerd Font";
      };
      # 强制 scale=1 与 niri 对齐，避免自动算出的 1.47 分数缩放导致画面模糊。
      output = {
        name = "eDP-2";
        scale = 1;
      };
    };
  };

  # 把头像装进 AccountsService，供 Noctalia greeter 显示。
  systemd.tmpfiles.settings."10-noctalia-greeter-avatar" = {
    "/var/lib/AccountsService".d = {
      mode = "0755";
      user = "root";
      group = "root";
    };
    "/var/lib/AccountsService/icons".d = {
      mode = "0775";
      user = "root";
      group = "root";
    };
    # accounts-daemon 的 ensure_directory 要求 users/ 恰好是 0700。
    "/var/lib/AccountsService/users".d = {
      mode = "0700";
      user = "root";
      group = "root";
    };
    "/var/lib/AccountsService/icons/hy"."L+" = {
      argument = "${avatar}";
      mode = "0644";
      user = "root";
      group = "root";
    };
    # accounts-daemon 启动时会对 users/ 里每个文件 chmod 0600 并 stat 校验，
    # 符号链接会跟随到只读 store 导致 chmod 报 EROFS，进而使守护进程直接退出
    # （main.c 的 on_bus_acquired），整个 AccountsService 失效、头像自然不显示。
    # 所以这里必须是真实文件。f+ 无法覆盖已存在的符号链接（会 ELOOP），
    # 故先用 R 删除（systemd-tmpfiles-setup 带 --remove，R 才会生效），
    # 同路径下规则按字母序生成，R 排在 f+ 之前，正好先删后建。
    "/var/lib/AccountsService/users/hy"."R" = { };
    "/var/lib/AccountsService/users/hy"."f+" = {
      argument = "${accountsserviceUserConfig}";
      mode = "0600";
      user = "root";
      group = "root";
    };
  };
}
