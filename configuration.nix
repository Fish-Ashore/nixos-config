# NixOS 配置入口。
# 各模块按功能拆分为扁平文件，均在 configuration.nix 同目录下，
# 由本文件统一 import。

{ inputs, ... }:

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
  ];

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    inputs.nur.overlays.default

#     # linux-firmware 20260910 的 yellow_carp(Rembrandt) DMCUB 固件为 0x0400004A，
#     # 与 6.18.52 内核配合会导致 PSP 加载失败，固定回可用的 20260810(0x0400004C)。
#     (final: prev: {
#       linux-firmware = prev.linux-firmware.overrideAttrs (old: {
#         version = "20260810";
#         src = prev.fetchFromGitLab {
#           owner = "kernel-firmware";
#           repo = "linux-firmware";
#           tag = "20260810";
#           hash = "sha256-P/fPpqaatp8Z2GV+I/OChiWGn6AhV+8w1RMFuX/LqHc=";
#         };
#       });
#     })
#
#     # opencode 1.18.30 在 bun 1.4.2 下编译出的二进制会在发送首个 prompt 时崩溃：
#     #   SystemPrompt.environment: TypeError: undefined is not an object ('a.name')
#     # 表面显示为 "Unexpected server error"，但实际发生在任何网络请求之前。
#     # 上游修复(nixpkgs#564101)：关闭 Bun 编译期的代码分割(splitting)。
#     (final: prev: {
#       opencode = prev.opencode.overrideAttrs (old: {
#         postPatch = (old.postPatch or "") + ''
#           substituteInPlace packages/opencode/script/build.ts \
#             --replace-fail 'splitting: true,' 'splitting: false,'
#         '';
#       });
#     })
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
  # systemd.services.nix-daemon.environment = {
  #   http_proxy = "http://127.0.0.1:7890";
  #   https_proxy = "http://127.0.0.1:7890";
  #   all_proxy = "socks5://127.0.0.1:7890";
  #   no_proxy = "localhost,127.0.0.1,::1";
  #   NIX_SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
  # };

  systemd.services.nix-daemon.environment = {
    http_proxy = "http://10.10.145.228:7890";
    https_proxy = "http://10.10.145.228:7890";
    all_proxy = "socks5://10.10.145.228:7890";
    no_proxy = "localhost,127.0.0.1,::1";
    NIX_SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
  };

  # stateVersion 请勿随意修改，详见 `man configuration.nix`
  system.stateVersion = "26.05";
}
