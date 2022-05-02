# 这个项目包括了什么

## 数据库

数据库包括以下几个（Sql和NoSql）

- postgres
- redis
- mysql

## 网络服务

- Cloudreve [一个公有云文件系统🔗](https://github.com/cloudreve/Cloudreve)
- RSSHub [一个RSS生成器🔗](https://github.com/DIYgod/RSSHub)
- Netdata [性能实时监测🔗](https://github.com/netdata/netdata)

# 如何使用这个项目(安装)

## Clone

`git clone https://github.com/Kerite/my-docker-composes.git`

## 进入目录

`cd ./my-docker-composes`

## 执行脚本

### Windows

首先，确保 docker-compose 可用: `docker-compose --version`
然后，运行 `.\deploy.bat` 即可

### Linux

使用你喜欢的终端执行以下命令：

```
```

# 细节

## 数据库与外部网络隔离

在数据库的 `docker-compose.yml` 内使用 `expose: 端口`，使端口暴露给网络中的服务而不是主机

## 网络服务通过bridge网络接口使用数据库

`docker-compose`默认会创建一个名称为 `${文件夹名称}_default` 的类型为 `bridge`的网络(可以通过`docker network list`查看所有的网络接口)
，其他服务需要连接到这个网络只需要在文件中定义类似以下内容即可：

```yml
version: '3'
services:
  ${服务名}:
    networks:
      - default
      - ${数据库compose目录}_default
# ...
networks:
  ${数据库compose目录}_default:
    external: true
```

## 所有网络服务统一通过 nginx-proxy 反向代理到互联网

这里使用了 nginx-proxy ([Link 🔗](https://github.com/nginx-proxy/nginx-proxy))，它可以识别 docker 容器中的 `VIRTUAL_HOST` 并获取它们 expose
的端口，并自动把 `VIRTUAL_HOST` 反向代理到这些容器上。

当然这么做有个前提就是 nginx-proxy 所在的容器可以访问到这些端口。

这里的解决方法是首先手动创建一个叫 proxynet 的网络：

```command
docker network create proxynet
```

然后把 nginx-proxy 和网络服务都添加到这个网络中（方便起见，我直接使用了这些服务的 default 网络）：

```yml
version: '3'
services:
  ${服务名}:
    expose:
      - ${暴露的端口号}
networks:
  default:
    external:
      name: proxynet
```

## Docker相关

本项目创建了以下volume:

- mysql-data: 用于持久化mysql的数据
- redis-data: 用于持久化redis的数据
- postgres-data: 用于持久化postgres的数据
