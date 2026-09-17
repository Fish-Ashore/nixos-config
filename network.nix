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

  # 关闭 WiFi 省电，缓解 MT7921K (RZ608) 频繁掉线
  networking.networkmanager.wifi.powersave = false;

  # 关闭 PCIe ASPM，进一步稳定 mt7921e 驱动
  boot.kernelParams = [ "pcie_aspm.policy=performance" ];
}
