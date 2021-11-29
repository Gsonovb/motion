# motion-docker

[![Docker Image CI-CD](https://github.com/Gsonovb/motion/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/Gsonovb/motion/actions/workflows/ci-cd.yml)  [![Code Scanning](https://github.com/Gsonovb/motion/actions/workflows/trivy-analysis.yml/badge.svg)](https://github.com/Gsonovb/motion/actions/workflows/trivy-analysis.yml)



[English](README.md) | [简体中文](README.zh-cn.md) 



这是 [motion](https://motion-project.github.io/index.html) 的容器化项目，使用官方的安装包制作。

提供以下平台映像：
- linux/amd64
- linux/arm64
- linux/arm/v7


## 如何使用

### 系统需求

在开始之前请确保系统中已经安装以下工具

1. [Docker Engine](https://docs.docker.com/engine/install/)
2. [Docker-compose](https://docs.docker.com/compose/install/)







### 快速启动


1. 创建configs文件夹，并创建相机配置文件，可以参考这个[示例](camera1-dist.conf)。
2. 使用以下命令启动motion
```bash
docker run -p 8080:8080  -p 8081:8081 \
      -v $(pwd)/configs:/etc/motion/conf.d  \
      -v $(pwd)/store:/store \
       ghcr.io/gsonovb/motion:latest
```
3. 访问 http://localhost:8080/



### 高级使用

1. 创建configs文件夹，并创建相机配置文件，可以参考这个[示例](camera1-dist.conf)。
2. （可选）下载 [motion.conf](motion.conf) 配置文件，并根据需求修改配置
3. 将以下内容保存到 `Docker-Compose.yml` 文件中。 （或者，下载[Docker-Compose.yml](Docker-Compose.yml) )

```YAML
version: '3.4'

services:
  motion:
    image: ghcr.io/gsonovb/motion:latest
    container_name: motion
    restart: unless-stopped
    deploy:
      resources:
        limits:
          cpus: '2.00'
          memory: 2048M
        reservations:
          cpus: '0.25'
          memory: 20M
    ports:
      # Use ports defined in the configuration file
      - 8080:8080
      - 8081:8081
    volumes:
      # Motion Dconfiguration file
      #- ./motion.conf:/etc/motion/motion.conf
      # Cameras configuration file
      - ./configs:/etc/motion/conf.d
      # output Store
      - ./store:/store
```

3. 使用 `docker-compose up -d` 命令运行编排
4. 访问 http://localhost:8080/



> 有关 motion 配置文件请参考 [配置文件帮助](https://motion-project.github.io/motion_config.html#configfiles)



## 贡献

有关对该项目做出贡献的信息，请参见[CONTRIBUTING](CONTRIBUTING.zh-cn.md)。

该项目采用了[贡献者契约](http://contributor-covenant.org/)定义的行为准则。


## 许可

此项目使用 [MIT license](LICENSE).
