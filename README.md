# nixos-config

我的 NixOS + Home Manager 配置。各模块按功能拆分为扁平文件，入口为 `configuration.nix`。

## 变更记录

### 2026-09-14 迁移到 Noctalia v5 桌面外壳

Noctalia v5 自带 bar / launcher / 通知 / 锁屏 / 空闲管理 / 剪贴板 / 壁纸，
因此删除了被它取代的软件：

| 原软件 | 用途 | 替代 |
| --- | --- | --- |
| waybar | 状态栏 | noctalia bar |
| fuzzel | 应用启动器 | noctalia launcher |
| mako | 通知守护进程 | noctalia 通知 |
| hypridle | 空闲管理（DPMS/锁屏/挂起） | noctalia idle |
| hyprlock | 锁屏 | noctalia lockscreen |
| cliphist | 剪贴板历史 | noctalia clipboard |
| awww | 壁纸 | noctalia wallpaper |

改动文件：

- `home.nix`：删除 `fuzzel` / `mako` / `hypridle` / `cliphist` 包及 `services.cliphist`；保留 `wl-clipboard`。
- `display.nix`：删除 `programs.waybar.enable`、`programs.hyprlock.enable`、`security.pam.services.hyprlock`。
- `packages.nix`：删除 `awww`。
- `~/.config/niri/config.kdl`（不在本仓库）：
  - 移除 `spawn-at-startup "mako"`，保留 `spawn-at-startup "noctalia"`。
  - `Mod+Alt+V` → `noctalia msg panel-toggle clipboard`
  - `Mod+D` → `noctalia msg panel-toggle launcher`
  - `Super+Alt+L` → `noctalia msg session lock`
  - 删除 fuzzel 的 layer 规则与 awww/waybar/hypridle/swaybg 的注释残留。

Noctalia 常用 IPC 命令（`noctalia msg ...`）：

```sh
noctalia msg panel-toggle launcher      # 应用启动器
noctalia msg panel-toggle clipboard     # 剪贴板历史
noctalia msg panel-toggle control-center # 控制中心
noctalia msg session lock               # 锁屏
noctalia msg session lock-and-suspend   # 锁屏并挂起
noctalia msg dpms-off                   # 关闭显示器
noctalia msg wallpaper-next             # 下一张壁纸
noctalia msg caffeine-toggle            # 切换空闲抑制
```

注意：`~/.config/hypr/hyprlock.conf`、`hypridle.conf`、`hyprlock.png` 为迁移前遗留文件，
当前未使用（窗口管理器为 niri），可自行删除。
