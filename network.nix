# 网络：主机名 / NetworkManager / 防火墙 / 用户代理。
{ ... }:

{
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  networking.firewall.enable = true;

  # 登录会话的代理环境变量（若代理不支持可去掉 all_proxy）
  environment.sessionVariables = {
    http_proxy = "http://127.0.0.1:7890";
    https_proxy = "http://127.0.0.1:7890";
    all_proxy = "socks5://127.0.0.1:7890";
    no_proxy = "localhost,127.0.0.1,::1";
  };
}
