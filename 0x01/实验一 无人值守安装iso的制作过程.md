# 实验一 无人值守安装iso的制作过程

## 一、实验目的

- [x] 如何配置无人值守安装iso并在Virtualbox中完成自动化安装。

- [x] Virtualbox安装完Ubuntu之后新添加的网卡如何实现系统开机自动启用和自动获取IP？

- [x] 如何在虚拟机和宿主机之间传输文件？

## 二、实验环境

- 主机：Mac / 虚拟机：ubuntu-18.04.1-server-amd64

- 网络配置：NAT/ host-only（192.168.68.3）本网卡用于虚拟机和主机之间的通信

- 先「有人值守」方式安装好 **一个可用的 Ubuntu 系统环境** , 首先在virtualbox安装ubuntu-18.04-server-amd64，用```ifconfig -a ```查看网络接口配置信息，启用```dhcp```

```bash
# 启用dhcp
sudo dhclient enp0s8
```

![](/0x01/images/dhc.jpg)

- 开启ssh服务宿主机通过ssh远程连接虚拟机

![](/0x01/images/Remote_Connection1.jpg)

![](/0x01/images/Remote_Connection2.jpg)

- 在Ubuntu 18.04 Desktop虚拟机中，开启ssh服务。

```bash
# 如果没有ssh，按照以下命令安装。
sudo apt install openssh-server

# 查看ssh是否正确启动
ps -e | grep ssh

# 重启ssh
service ssh restart
```

- 在MAC上尝试远程登录，`ssh cookie@192.168.68.3`，显示登录成功。

![](/0x01/images/ssh.jpg)

# 三、实验过程

## 1、创建iso镜像文件

```bash
# 在当前用户目录下创建一个用于挂载iso的文件目录。
mkdir iso
# 将宿主机中下载好的镜像传入虚拟机
```

![](/0x01/images/trans_iso_in.jpg)

![](/0x01/images/ls_iso.jpg)



```bash
# 在当前用户目录下创建一个用于挂载iso的文件目录。
mkdir loopdir
# 挂载iso镜像文件到这个目录。
sudo mount -o loop ubuntu-18.04.1-server-amd64.iso loopdir
# 新建一个目录用于克隆光盘
mkdir copydir
# 克隆光盘
rsync -av copydir/ cd
# 卸载iso镜像
sudo umount loopdir
```

![](/0x01/images/mount_iso.jpg)

![](/0x01/images/ls_mount_iso.jpg)



## 2、 进入入`copydir`工作目录下，编辑Ubuntu安装引导界面

```bash
# 进入copydir工作目录下
cd ~/copydir
# 打开文件
vim isolinux/txt.cfg
# 添加以下内容到该文件后强制保存退出
label autoinstall
  menu label ^Auto Install Ubuntu Server
  kernel /install/vmlinuz
  append  file=/cdrom/preseed/ubuntu-server-autoinstall.seed debian-installer/locale=en_US console-setup/layoutcode=us keyboard-configuration/layoutcode=us console-setup/ask_detect=false localechooser/translation/warn-light=true localechooser/translation/warn-severe=true initrd=/install/initrd.gz root=/dev/ram rw quiet
```

![](/0x01/images/auto_install.jpg)



```bash
# 修改配置缩短超时等待时间
# timeout 10
sudo vi isolinux/isolinux.cfg
```

![](/0x01/images/time_out.jpg)

```bash
# 下载已经定制好的ubuntu-server-autoinstall.seed
~~sudo wget https://github.com/c4pr1c3/LinuxSysAdmin/blob/master/exp/chap0x01/cd-rom/preseed/ubuntu-server-autoinstall.seed~~
# 移动到指定目录下
sudo mv ubuntu-server-autoinstall.seed ~/copydir/preseed/
```

![](/0x01/images/down_seed.jpg)

![](/0x01/images/ls_seed.jpg)



```bash
# 重新生成md5sum.txt
find . -type f -print0 | xargs -0 md5sum > /tmp/md5sum.txt
sudo mv /tmp/md5sum.txt md5sum.txt
```

![](/0x01/images/md5sum.jpg)

![](/0x01/images/ls_md5sum.jpg)



```bash
# 新建shell文件
sudo vim shell
# 添加以下内容到shell文件中
IMAGE=custom.iso
BUILD=~/cd/

mkisofs -r -V "Custom Ubuntu Install CD" \
          -cache-inodes \
          -J -l -b isolinux/isolinux.bin \
          -c isolinux/boot.cat -no-emul-boot \
          -boot-load-size 4 -boot-info-table \
          -o $IMAGE $BUILD
# 如果目标磁盘之前有数据，则在安装过程中会在分区检测环节出现人机交互对话框需要人工选择
```

![](/0x01/images/shell.jpg)



```bash
# 执行shell命令
bash shell
# 上条指令执行时提示错误，安装genisoimage
sudo apt install genisoimage
```

![](/0x01/images/bash_shell.jpg)



## 3、传出虚拟机中生成的无人值守镜像到宿主机

![](/0x01/images/trans_iso_out.jpg)

![](/0x01/images/ls_out_iso.jpg)

！！！安装失败……(｡ì _ í｡) 

![](/0x01/images/fail.jpg)

下一步，分析失败原因，继续安装……

### 失败原因

👇以下代码执行后得到的并不是期望的 `.seed` 文件，实际上是一个 HTML 文件。

```bash
# 下载已经定制好的ubuntu-server-autoinstall.seed
~~sudo wget https://github.com/c4pr1c3/LinuxSysAdmin/blob/master/exp/chap0x01/cd-rom/preseed/ubuntu-server-autoinstall.seed~~
# 移动到指定目录下
sudo mv ubuntu-server-autoinstall.seed ~/copydir/preseed/
```

### 解决方法

- 下载老师提供的seed文件到宿主机

- 使用ssh将seed文件放入虚拟机的`/copydir/preseed`目录下

- 可能会出现remote open(路径名): Permission Denied的情况，目标路径没有写权限，此时回到虚拟机，通过`sudo chmod -R 775 目标路径`开放写权限即可

- 传输完成结果

  ![](/0x01/images/ls_seed.jpg)

### 4、无人值守iso镜像录屏

[无人值守iso镜像录屏链接]()

# 参考链接

[CUCCS/linux-2019-LeLeF](https://github.com/CUCCS/linux-2019-LeLeF/blob/29769e9d5195105c5c54a22e0d7edd0400f95f3d/chap0x01VirtualBox%20无人值守安装Unbuntu系统实验/chap0x01%20VirtualBox%20无人值守安装Unbuntu系统实验.md)

[CUCCS/linux-2019-UP1998](https://github.com/CUCCS/linux-2019-UP1998/blob/135d24f24d2e73ab6b9b79e6219193c40a466120/linux-1/linux-1.md)

[CUCCS/linux-2019-FukurouNarthil](https://github.com/CUCCS/linux-2019-FukurouNarthil/blob/68242ef682cd9466c23013e7bcc82ecf8dc5ec53/exp0x01/exp0x01.md)

ncv xz