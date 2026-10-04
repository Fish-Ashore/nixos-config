# NixOS 配置入口。
# 各模块按功能拆分为扁平文件，均在 configuration.nix 同目录下，
# 由本文件统一 import。

{ inputs, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix # 自动生成，勿改
    ./boot.nix
    ./hardware.nix
    ./network.nix
    ./locale.nix
    ./display.nix
    ./programs.nix
    ./packages.nix
    ./virt.nix
    ./users.nix
    ./gnome.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    inputs.nur.overlays.default
  ];

  # 启用 flakes / nix 新命令
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # 每周自动 GC，删除 14 天前的旧世代
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # 让 nix-daemon 的构建（含 fetchgit 沙箱拉取）通过代理访问外网，
  # 否则沙箱内无法连接 GitHub 等（此网络需经 HTTP 代理出网）。
  systemd.services.nix-daemon.environment = {
    http_proxy = "http://127.0.0.1:7890";
    https_proxy = "http://127.0.0.1:7890";
    all_proxy = "socks5://127.0.0.1:7890";
    no_proxy = "localhost,127.0.0.1,::1";
    NIX_SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
  };

  # systemd.services.nix-daemon.environment = {
  #   http_proxy = "http://192.168.114.82:7890";
  #   https_proxy = "http://192.168.114.82:7890";
  #   all_proxy = "socks5://192.168.114.82:7890";
  #   no_proxy = "localhost,127.0.0.1,::1";
  #   NIX_SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
  # };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      openssl
      # 如果遇到其他缺失库，可在此添加
    ];
  };

  # stateVersion 请勿随意修改，详见 `man configuration.nix`
  system.stateVersion = "26.05";
}
