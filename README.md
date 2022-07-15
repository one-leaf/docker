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

1. 安装Docker

    `sudo apt-get update`

    `sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin`

1. 添加当前用户到 Docker 组

    `sudo groupadd docker`

    `sudo usermod -aG docker $USER`

    `newgrp docker`

1. 开机自动启动 Docker 服务

    `sudo systemctl enable docker.service`

    `sudo systemctl enable containerd.service`

6. 开启 Docker 支持资源限制

    编辑 /etc/default/grub 找到 GRUB_CMDLINE_LINUX 行，改为：

    `GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"`

    更新 grup

    `sudo update-grub`

    重启服务器

