# 虚拟化：libvirt + QEMU/KVM，virt-manager 图形管理。
{ pkgs, ... }:

{
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      # 仅支持宿主机架构（x86_64），省空间；需要模拟其它架构再换 pkgs.qemu
      package = pkgs.qemu_kvm;
      # 默认以 root 运行 QEMU，读写 /var/lib/libvirt 下的磁盘镜像更方便
      runAsRoot = true;
      # 模拟 TPM 2.0，安装 Windows 11 等强制要求 TPM 的系统时需要
      swtpm.enable = true;
    };
    # 防火墙后端按 networking.nftables 是否启用自动选择，无需手动设置
  };

  # virt-manager 图形界面（自动连接 qemu:///system）
  programs.virt-manager.enable = true;
}
