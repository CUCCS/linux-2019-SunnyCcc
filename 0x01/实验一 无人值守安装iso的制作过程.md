# 实验一 无人值守安装iso的制作过程

## 一、实验目的

- 配置无人值守安装iso并在Virtualbox中完成自动化安装

## 二、实验环境

- 主机：Mac
- 虚拟机：ubuntu-18.04.1-server-amd64



- 网络配置：NAT/ host-only（192.168.68.3）本网卡用于虚拟机和主机之间的通信
- 首先在virtualbox安装ubuntu-18.04-server-amd64，用ifconfig -a 查看网络接口配置信息，启用dhcp

```
# 启用dhcp
sudo dhclient enp0s8
```

![3](/0x01/3.jpg)

- 开启ssh服务, 宿主机通过ssh远程连接虚拟机

![4](/0x01/4.jpg)

![5](/0x01/5.jpg)

- 在Ubuntu 18.04 Desktop虚拟机中，开启ssh服务。

```
# 如果没有ssh，按照以下命令安装。
sudo apt install openssl-server

# 查看ssh是否正确启动
ps -e | grep ssh

# 重启ssh
service ssh restart
```

- 在MAC上尝试远程登录，`ssh cookie@192.168.68.3`，显示登录成功。

![6](/0x01/6.jpg)

# 三、实验过程

## 1、创建iso镜像文件

```
# 在当前用户目录下创建一个用于挂载iso的文件目录。
mkdir iso
# 将宿主机中下载好的镜像传入虚拟机
```

![13](/0x01/13.jpg)

![14](/0x01/14.jpg)



```
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

![15](/0x01/15.jpg)

![16](/0x01/16.jpg)



## 2、 进入入`copydir`工作目录下，编辑Ubuntu安装引导界面

```
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

![31](/0x01/31.jpg)



```
# 修改配置缩短超时等待时间
# timeout 10
sudo vi isolinux/isolinux.cfg
```

![32](/0x01/32.jpg)



```
# 下载已经定制好的ubuntu-server-autoinstall.seed
sudo wget https://github.com/c4pr1c3/LinuxSysAdmin/blob/master/exp/chap0x01/cd-rom/preseed/ubuntu-server-autoinstall.seed
# 移动到指定目录下
sudo mv ubuntu-server-autoinstall.seed ~/copydir/preseed/
```

![22](/0x01/22.jpg)

![23](/0x01/23.jpg)



```
# 重新生成md5sum.txt
find . -type f -print0 | xargs -0 md5sum > /tmp/md5sum.txt
sudo mv /tmp/md5sum.txt md5sum.txt
```

![34](/0x01/34.jpg)

![24](/0x01/24.jpg)



```
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

![35](/0x01/35.jpg)



```
# 执行shell命令
bash shell
# 上条指令执行时提示错误，安装genisoimage
sudo apt install genisoimage
```

![36](/0x01/36.jpg)



## 3、传出虚拟机中生成的无人值守镜像到宿主机

![27](/0x01/27.jpg)

![38](/0x01/38.jpg)

！！！安装失败……(｡ì _ í｡) 

![37](/0x01/37.jpg)

下一步，分析失败原因，继续安装……

# 参考链接

[CUCCS/linux-2019-LeLeF/](https://github.com/CUCCS/linux-2019-LeLeF/blob/29769e9d5195105c5c54a22e0d7edd0400f95f3d/chap0x01VirtualBox%20无人值守安装Unbuntu系统实验/chap0x01%20VirtualBox%20无人值守安装Unbuntu系统实验.md)

[CUCCS/linux-2019-UP1998/](https://github.com/CUCCS/linux-2019-UP1998/blob/135d24f24d2e73ab6b9b79e6219193c40a466120/linux-1/linux-1.md)

