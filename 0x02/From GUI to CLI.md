# From GUI to CLI

### 实验要求

- [x] 确保本地已经完成**asciinema auth**，并在[asciinema](https://asciinema.org/)成功关联了本地账号和在线账号

- [x] 上传本人亲自动手完成的**vimtutor**操作全程录像

- [x] 在自己的github仓库上新建markdown格式纯文本文件附上asciinema的分享URL

### 实验环境

##### Ubuntu18.04 Server

- 网卡：NAT、Host-Only
- 镜像：ubuntu-18.04.1-server-amd64.iso

##### 在asciinema注册一个账号，并在本地安装配置好asciinema

```shell
# Install 
sudo apt install asciinema

# Link your install ID with your asciinema.org user account
asciinema auth
```

### vimtutor操作全程录像

#### Lesson-1

<a href="https://asciinema.org/a/234446?autoplay=1"><img src="https://asciinema.org/a/234446.png" width="666"/></a>

#### Lesson-2

<a href="https://asciinema.org/a/234450?autoplay=1"><img src="https://asciinema.org/a/234450.png" width="666"/>

#### Lesson-3

<a href="https://asciinema.org/a/234452?autoplay=1"><img src="https://asciinema.org/a/234452.png" width="666"/>

#### Lesson-4

<a href="https://asciinema.org/a/234457?autoplay=1"><img src="https://asciinema.org/a/234457.png" width="666"/>

#### Lesson-5

<a href="https://asciinema.org/a/234714?autoplay=1"><img src="https://asciinema.org/a/234714.png" width="666"/>

#### Lesson-6

<a href="https://asciinema.org/a/234721?autoplay=1"><img src="https://asciinema.org/a/234721.png" width="666"/>

#### Lesson-7

<a href="https://asciinema.org/a/234728?autoplay=1"><img src="https://asciinema.org/a/234728.png" width="666"/>

### vimtutor完成后的自查清单

##### 你了解vim有哪几种工作模式？

- Normal模式
- Insert模式
- Visual模式

##### Normal模式下，从当前行开始，一次向下移动光标10行的操作方法？如何快速移动到文件开始行和结束行？如何快速跳转到文件中的第N行？

- 一次向下移动光标10行：```10j```
- 快速移动到文件开始行：```gg```
- 快速移动到文件结束行：```G```
- 快速跳转到文件中的第N行：```Ngg```

##### Normal模式下，如何删除单个字符、单个单词、从当前光标位置一直删除到行尾、单行、当前行开始向下数N行？

- 删除单个字符：```x```
- 删除单个单词：```dw```
- 从当前光标位置一直删除到行尾：```d$```
- 从当前光标位置一直删除到单行：```dd```
- 从当前光标位置一直删除到当前行开始向下数N行：```dNd```

##### 如何在vim中快速插入N个空行？如何在vim中快速输入80个-？

- 快速插入N个空行：```No <ESC>```
- 快速插入80个-：插入模式下``` CTRL+O 80i- ESC```

##### 如何撤销最近一次编辑操作？如何重做最近一次被撤销的操作？

- 撤销最近一次编辑操作：```u```
- 重做最近一次被撤销的操作：```Ctrl+R```

##### vim中如何实现剪切粘贴单个字符？单个单词？单行？如何实现相似的复制粘贴操作呢？

- 剪切单个字符：```x```
- 剪切单个单词：```dw```
- 剪切单行：```d$```
- 粘贴：```p```
- 相似的复制粘贴操作：光标停留在需要复制的起始字符上，`v`进入Visual模式，选择需要复制的文字(高亮），选好后`y`复制，光标移动到需要粘贴的地方，`p`粘贴。

##### 为了编辑一段文本你能想到哪几种操作方式（按键序列）？

- 打开/创建文本
  - `vim <name>`
- 退出```<Esc>```
  - 保存
    - `:wq!`
  - 不保存
    - `:q!`

##### 查看当前正在编辑的文件名的方法？查看当前光标所在行的行号的方法？

- 查看当前正在编辑的文件名:```Ctrl+G```
- 查看当前光标所在行的行号的方法:```Ctrl+G```

##### 在文件中进行关键词搜索你会哪些方法？如何设置忽略大小写的情况下进行匹配搜索？

- 在文件中进行关键词搜索:```/+关键字```

- 设置忽略大小写的情况下进行匹配搜索：```:set ignorecase```

##### 如何将匹配的搜索结果进行高亮显示？如何对匹配到的关键词进行批量替换？

- 设置高亮查找:```:set hlsearch```

- 将当前文件中全替换p1为p2:```:%s/p1/p2/g``` 

##### 在文件中最近编辑过的位置来回快速跳转的方法？

- ``

##### 如何把光标定位到各种括号的匹配项？例如：找到(, [, or {对应匹配的),], or }

- ```%```

##### 在不退出vim的情况下执行一个外部程序的方法？

- ```:!ls```

##### 如何使用vim的内置帮助系统来查询一个内置默认快捷键的使用方法？如何在两个不同的分屏窗口中移动光标？

- 使用vim的内置帮助系统来查询一个内置默认快捷键的使用方法:```:help w```

- 在两个不同的分屏窗口中移动光标:```Ctrl+W w```