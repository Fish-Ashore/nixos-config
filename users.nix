# 用户账户定义。用户级软件包见 home.nix。
{ pkgs, ... }:

{
  users.users."hy" = {
    isNormalUser = true;
    description = "hy";
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd" # 允许管理 KVM 虚拟机（无需密码）
      "input"
    ];
  };
}
