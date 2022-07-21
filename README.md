# motion-docker

[![Docker Image CI-CD](https://github.com/Gsonovb/motion/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/Gsonovb/motion/actions/workflows/ci-cd.yml)  [![Code Scanning](https://github.com/Gsonovb/motion/actions/workflows/trivy-analysis.yml/badge.svg)](https://github.com/Gsonovb/motion/actions/workflows/trivy-analysis.yml)


[English](README.md) | [简体中文](README.zh-cn.md) 

This is [motion](https://motion-project.github.io/index.html) The container project is made with the official installation package.

Provide the following platform images:
- linux/amd64
- linux/arm64
- linux/arm/v7


## How to use
### System requirements

Before you begin, make sure that the following tools are installed on your system

1. [Docker Engine]( https://docs.docker.com/engine/install/ )
2. [Docker-compose]( https://docs.docker.com/compose/install/ )


### Quick start

1. Create the configurations folder and create the camera configuration file. Refer to this [example](camera1-dist.conf).
2. Start motion with the following command

    ```bash
    docker run -p 8080:8080  -p 8081:8081 \
        -v $(pwd)/configs:/etc/motion/conf.d  \
        -v $(pwd)/store:/store \
        ghcr.io/gsonovb/motion:latest
    ```

3. Visit http://localhost:8080/


### Advanced use
1. Create the configurations folder and create the camera configuration file. Refer to this [example](camera1-dist.conf).
2. (optional) download the [motion.conf](motion.conf) configuration file and change it for your need, refer to [configuration file help](https://motion-project.github.io/motion_config.html#configfiles)
3. Save the following contents to the 'docker-compose.yml' file. (or, download [docker-compose.yml](docker-compose.yml) )

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
3. Use the 'docker compose up - D' command to run orchestration
4. Visit http://localhost:8080/


## CONTRIBUTING
For information on contributing to the project, see [CONTRIBUTING](CONTRIBUTING.md).
The project adopts [Contributor Contract](http://contributor-covenant.org/) Defined code of conduct.

## License

This project is licensed with the [MIT license](LICENSE).

