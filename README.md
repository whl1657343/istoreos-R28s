# iStoreOS for NanoPi R28S

本仓库已适配 FriendlyElec NanoPi R28S（RK3528A），用于构建可从 SD 卡启动的 iStoreOS 镜像。

## 版本与默认配置

| 项目 | 当前配置 |
| --- | --- |
| 系统 | iStoreOS 24.10.8（基于 OpenWrt 24.10.8） |
| 内核 | Linux 6.6.144 |
| 目标平台 | rockchip/armv8（aarch64_generic，musl） |
| 设备 | FriendlyElec NanoPi R28S / RK3528A |
| 管理地址 | `http://192.168.100.1` |
| 登录用户名 | `root` |
| 默认密码 | 空密码（密码栏留空） |

首次登录后请立即在“系统 → 管理权”中设置 root 密码。

## 网络接口

| 设备丝印网口 | Linux 接口 | 默认角色 | 默认设置 |
| --- | --- | --- | --- |
| 网口 1 | `eth0` | WAN | DHCP 客户端 |
| 网口 2 | `eth1` | LAN | `192.168.100.1/24`，DHCP 服务器 |

LAN 的 DHCP 地址池为 `192.168.100.100` 到 `192.168.100.249`。电脑接入网口 2 后应设置为“自动获得 IPv4 地址”；获取地址后访问 `http://192.168.100.1`。

## Ubuntu / WSL 编译环境

请在 Ubuntu 原生 Linux 文件系统中编译，例如 WSL 的 `/home/toor/r28s`。不要把源码放在 `/mnt/c` 等 Windows 挂载目录，避免大小写、符号链接和 I/O 性能问题。

安装依赖：

```sh
sudo apt update
sudo apt install -y build-essential clang flex bison g++ gawk gcc-multilib \
  g++-multilib gettext git libncurses5-dev libssl-dev python3-setuptools \
  rsync swig unzip zlib1g-dev file wget
```

进入源码目录并初始化 feeds：

```sh
cd /home/toor/r28s
./scripts/feeds update -a
./scripts/feeds install -a
```

本仓库中的 `.config` 已选择 R28S。若 `.config` 被删除或需要重新选择目标，执行：

```sh
make menuconfig
```

在菜单中选择：

```text
Target System      → Rockchip
Subtarget          → ARMv8 boards (64 bit)
Target Profile     → FriendlyARM NanoPi R28S
```

保存后执行：

```sh
make defconfig
make download -j16
make -j16 V=s
```

`-j16` 适合 16 线程 CPU；内存不足、构建异常或需要更稳定的日志时，改用 `make -j1 V=s`。首次全量构建需要下载工具链和源码，耗时通常较长。

## 构建产物与刷写

完成后，SD 卡镜像位于：

```text
bin/targets/rockchip/armv8/istoreos-rockchip-armv8-friendlyarm_nanopi-r28s-squashfs-sysupgrade.img.gz
```

将该 `.img.gz` 解压为 `.img`，使用 Balena Etcher、Rufus 或其他镜像写入工具写入 SD 卡的整个磁盘设备。写入完成后安全弹出 SD 卡，再插入 R28S 上电启动。

## 注意事项

- 此镜像是 SD 卡启动镜像，不要把它当作普通 `.ipk` 或仅复制到 SD 卡文件系统中。
- 首次启动约需数分钟；启动完成后，LAN 口会提供 DHCP 服务。
- 如果电脑没有获取到地址，先确认连接的是网口 2，再关闭并重新启用电脑网卡，或重新插拔网线以触发 DHCP 请求。
- 串口参数为 `1500000 8N1`。Windows 下可使用 COM 端口连接串口控制台。
- WAN（网口 1）默认使用 DHCP 获取上级网络地址；LAN（网口 2）用于本地管理。
- 编译失败时保留完整日志，优先使用 `make -j1 V=s` 重现首个报错；不要只依据最后几行的 `Error 2` 判断根因。
- 若修改了内核、设备树或镜像分区相关文件，建议执行 `make target/linux/clean` 后再重新构建目标镜像。
