# update log

> 2025年04月05日更新
- 默认`latest`标签,基于debian镜像,后续支持升级zerotier版本,当前版本`1.14.2`
- 增加`alpine`标签,基于alpine镜像,[由于许可证原因](https://github.com/zerotier/ZeroTierOne/issues/2020)zerotier版本将固定在`1.10.2-r0`
- 支持多CPU架构:amd64/arm64/armv7

# docker-zerotier-moon
A docker image to create ZeroTier moon in one setp.
**Update docker source to the latest version of zerotier**

#### If there is a problem with centos7 operation, add `--cap-add=NET_ADMIN --cap-add=SYS_ADMIN --device=/dev/net/tun` after `docker run`
## Usage

### Pull the image

```
# April 5, 2025 The latest version is 1.14.2, supporting future upgrades.
docker pull jonnyan404/zerotier-moon
OR
#Due to [license reasons](https://github.com/zerotier/ZeroTierOne/issues/2020), it will forever remain fixed at `1.10.2-r0`. If resolved in the future, updates will resume.
docker pull jonnyan404/zerotier-moon:alpine
```

### Start a container

```
docker run --name zerotier-moon -d --restart always -p 9993:9993/udp jonnyan404/zerotier-moon -4 1.2.3.4
```
 
- Replace `1.2.3.4` with your moon's IP.

- To show your moon id, run
```
docker logs zerotier-moon
```

**Notice:**
When creating a new container, a new moon id will be generated. To persist the identity when creating a new container, see **Mount ZeroTier conf folder** below.


# Docker Compose

`docker-compose.yml` example:

```yml
version: "3"

services:
  zerotier-moon:
#    cap_add:
#        - NET_ADMIN
#        - SYS_ADMIN
#    devices:
#        - /dev/net/tun
    image: jonnyan404/zerotier-moon
    container_name: "zerotier-moon"
    restart: always
    ports:
      - "9993:9993/udp"
    volumes:
      - ./config:/var/lib/zerotier-one
    command: -4 1.2.3.4
```

- Replace `1.2.3.4` with your moon's IPv4 address.

- To show your moon id, run
```
docker-compose logs
```


## Advanced usage

### Manage ZeroTier

```
docker exec zerotier-moon zerotier-cli
```

### Mount ZeroTier conf folder

```
docker run --name zerotier-moon -d --restart always -p 9993:9993 -p 9993:9993/udp -v ~/somewhere:/var/lib/zerotier-one jonnyan404/zerotier-moon -4 1.2.3.4 -6 2001:abcd:abcd::1
```

This will mount `~/somewhere` to `/var/lib/zerotier-one` inside the container, allowing your ZeroTier moon to presist the same moon id.  If you don't do this, when you start a new container, a new moon id will be generated.

### IPv6 support

```
docker run --name zerotier-moon -d -p 9993:9993/udp jonnyan404/zerotier-moon -4 1.2.3.4 -6 2001:abcd:abcd::1
```

Replace `1.2.3.4`, `2001:abcd:abcd::1` with your moon's IP. You can remove `-4` option in pure IPv6 environment.

### Custom port

```
docker run --name zerotier-moon -d -p 9994:9993/udp jonnyan404/zerotier-moon -4 1.2.3.4 -p 9994
```

Replace 9994 with your own custom port for ZeroTier moon.
