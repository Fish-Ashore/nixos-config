# SilentSDDM 主题模块。
{ inputs, ... }:

{
  imports = [ inputs.silentSDDM.nixosModules.default ];
  programs.silentSDDM = {
    enable = true;
    theme = "default";
    # settings = { ... }; # 详见模块示例
  };
}
