# docker
这里是一些docker的命令和配置

## 安装

1. 删除旧版本

   `sudo apt-get remove docker docker-engine docker.io containerd runc`

1. 安装软件源

   `sudo apt-get update`

   `sudo apt-get install ca-certificates curl gnupg lsb-release`

   `sudo mkdir -p /etc/apt/keyrings`

   `curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg`

   `echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null`

1. 安装 Docker

    `sudo apt-get update`

    `sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin`

1. 安装 docker-compose

    `sudo apt-get install python3-pip`

    `sudo pip install docker-compose -i https://pypi.douban.com/simple/`

1. 添加当前用户到 Docker 组

    `sudo groupadd docker`

    `sudo usermod -aG docker $USER`

    `newgrp docker`

1. 开机自动启动 Docker 服务

    `sudo systemctl enable docker.service`

    `sudo systemctl enable containerd.service`

1. 开启 Docker 支持资源限制

    编辑 /etc/default/grub 找到 GRUB_CMDLINE_LINUX 行，改为：

    `GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"`

    更新 grup

    `sudo update-grub`

    重启服务器

    `sudo reboot`


## 必须安装的容器

1. portainer docker的面板看

## 常用命令

  镜像名是指软件名字，容器名是正在运行的虚拟机名字

1. `docker run hello-world` 测试 Docker 是否正常
1. `docker ps`  看正在运行的容器
1. `docker stats` 看容器的资源消耗状态
1. `docker logs -f -n 10 容器名` 跟踪容器的日志，保留之前最后10行日志 
1. `docker run 镜像名` 运行一个容器
1. `docker inspect 容器名` 看一个正在运行的容器信息

