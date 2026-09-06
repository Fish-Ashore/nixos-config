# 时区 / 本地化 / 中文输入法。
{ pkgs, ... }:

{
  time.timeZone = "Asia/Shanghai";

  i18n.defaultLocale = "zh_CN.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-gtk # GTK 程序支持
        qt6Packages.fcitx5-chinese-addons # 中文拼音、五笔等支持
        # fcitx5-rime # 如用 Rime 引擎则启用
        fcitx5-pinyin-zhwiki # 基于中文维基百科的词库
        fcitx5-pinyin-moegirl # 萌娘百科词库
      ];
    };
  };
}
