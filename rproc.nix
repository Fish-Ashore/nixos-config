# rproc 系统监视器及其构建补丁。
{ inputs, pkgs, ... }:

let
  # 上游 rproc flake 有两个问题：
  # 1. 漏掉 fontconfig，导致 yeslogic-fontconfig-sys 的 build.rs 无法通过
  #    pkg-config 找到 fontconfig；最终包和用于缓存依赖的 cargoArtifacts
  #    都要补上，否则依赖层仍然构建失败。
  # 2. crane 的 cleanCargoSource 会把 build.rs 需要的 ui/*.slint 过滤掉，
  #    因此最终包改用完整源码。
  # 3. 沙箱里没有字体，slint 编译 .slint 时需要能解析出一个默认 sans-serif
  #    字体。makeFontsConf 生成的配置缺少 conf.d 里的别名规则（如
  #    sans-serif -> DejaVu Sans），所以这里手动包含 fontconfig 的 conf.d。
  # 4. slint-build 启用了 fontique 的 fontconfig-dlopen，构建脚本会在运行时
  #    dlopen libfontconfig.so.1，因此需要把 fontconfig 的 lib 放进
  #    LD_LIBRARY_PATH。
  # 5. rproc 通过 NVML（nvml-wrapper）检测 NVIDIA 独显，运行时 dlopen
  #    libnvidia-ml.so.1。NixOS 把它放在 /run/opengl-driver/lib，但该目录
  #    不在 rproc 的 RUNPATH 里，导致独显不显示；这里补上。
  rproc = inputs.rproc.packages.${pkgs.stdenv.hostPlatform.system}.default;
  rprocDeps = rproc.cargoArtifacts.overrideAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.fontconfig ];
  });
  fontsConf = pkgs.writeText "fonts.conf" ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
    <fontconfig>
      <include ignore_missing="yes">${pkgs.fontconfig.out}/etc/fonts/conf.d</include>
      <dir>${pkgs.dejavu_fonts}/share/fonts</dir>
    </fontconfig>
  '';
  rprocWithFontconfig = rproc.overrideAttrs (old: {
    cargoArtifacts = rprocDeps;
    src = inputs.rproc.outPath;
    buildInputs = (old.buildInputs or [ ]) ++ [
      pkgs.fontconfig
      pkgs.dejavu_fonts
    ];
    FONTCONFIG_FILE = fontsConf;
    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [ pkgs.fontconfig ];
    postFixup = (old.postFixup or "") + ''
      patchelf --add-rpath /run/opengl-driver/lib $out/bin/rproc
    '';
  });
in
{
  home.packages = [ rprocWithFontconfig ];
}
