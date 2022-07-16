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


## 推荐安装的容器

注意，下面的模板都需要调整模板中的 192.168.1.1 为你服务器的IP地址

1. run文件夹下面的常用脚本模板，

    脚本原则：
    
    - 其中数据均存放在主机的 /docker 目录，统一管理
    - 尽量不在脚本外面单独引入配置文件
    - 备份直接在容器内完成，可以在主机上直接访问

    脚本库：

    1. `portainer.sh` docker 面板
    1. `mysql.sh` mysql 数据库
    1. `postgres.sh` postgres 数据库
    1. `mongodb.sh` mongodb 数据库
    1. `zookeeper.sh` zookeeper 配置服务
    1. `mqtt.sh` 轻量级消息服务器
    1. `rabbitmq.sh` 消息服务


1. 服务器监控，看 monitoring 文件夹

    1. 采用 docker-compose 封装
        1. cadvisor docker容器实时监控
        1. node-exporter 服务器实时监控
        1. prometheus 监控数据采集器
        1. grafana 采集数据显示面板
    2. 监控面板
        1. 地址是 http://IP:3000
        2. 默认用户名 admin 密码 123456
        3. 设置
            1. 增加 Prometheus 数据源
                - 点击 左边工具条 Configuration 的 Data sources 界面
                - 点击 Add Data source ，选择 Prometheus 
                - Http 项下的 url 写：http://prometheus:9090 其他默认
                - 点击页面最底部的 Save & test 按钮，保存退出
            2. 增加 Dashboards 面板
                - 点击 左边工具条 Dashboards 的 Import 菜单
                - 输入 1860 ，点击 Load 安装 Node Exporter Full
                - 在下面的 Prometheus 鼠标输入兼容不太好，直接 tab 切换过去，按 space 空格键选择，回车确认
                - 完成了 服务器 的监控
                - 继续 导入 Docker 的监控， 编号是 15331 安装 Docker Container Dashboard
                - 所有的面板地址： https://grafana.com/grafana/dashboards/?dataSource=prometheus 

1. nginx 方案

    1. nginx 不推荐docker，有性能损失，直接实体机安装
    1. nginx 增加log的配置，修改采用json格式输出，方便es采集，具体看 nginx/log.conf
    1. 站点增加,确定输出json的日志和允许查询当前nginx实时状态：
        ```
            access_log /var/log/nginx/access.log main;
            location /nginx_status {
                stub_status;
                allow 172.17.0.1;        #only allow requests from docker
                deny all;                #deny all other hosts
            }
        ```
    1. 容器增加 nginx-exporter 输出当前状态，监控 Prometheus 增加采集对应的任务 具体看 nginx/monitoring 文件夹
    1. 在 grafana 面板中增加 编号为 11199 的面板 NGINX by nginxinc， 完成连接数监控
    1. 启动 filebeat + elasticsearch + kibana 方案，具体看 nginx/log 文件夹
    1. 完成配置后， 运行 start.sh 启动容器， 然后再运行 runonce.sh 创建 es 的用户
    1. 然后直接通过 http://IP:5601 访问日志数据，默认用户和密码是 elastic 密码 123456

## 常用命令

  镜像名是指软件名字；容器名是正在运行的虚拟机名字，也可以用容器ID

1. `docker run hello-world` 测试 Docker 是否正常
1. `docker ps`  看正在运行的容器
1. `docker stats` 看容器的资源消耗状态
1. `docker logs -f -n 10 容器名` 跟踪容器的日志，保留之前最后10行日志 
1. `docker run 镜像名` 运行一个容器
1. `docker inspect 容器名` 看一个正在运行的容器信息
1. `docker exec -it 容器名 /bin/bash` 进入一个容器
1. `docker cp src/. 容器名:/target`  复制主机上的文件到容器
1. `docker cp 容器名:/src/. target`  复制容器上的文件到主机
1. `docker exec -i 容器名 sh -c 'cat > /target/file' < /src/file` 野路子上传，配合tar不错,如下
1. `tar -czvf tmp.tar.gz *.* && docker exec -i container_id sh -c 'cat > ./bar/tmp.tar.gz && tar -xzvf tmp.tar.gz' < ./tmp.tar.gz` 呃,熟悉的用
