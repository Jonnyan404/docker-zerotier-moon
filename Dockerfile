## NOTE: to retain configuration; mount a Docker volume, or use a bind-mount, on /var/lib/zerotier-one
FROM debian:13-slim AS builder

ARG ZT_VERSION=1.14.2

# 安装基本依赖
RUN apt-get update && apt-get install -y curl gnupg ca-certificates wget apt-transport-https


RUN curl -s 'https://raw.githubusercontent.com/zerotier/ZeroTierOne/main/doc/contact%40zerotier.com.gpg' | gpg --import && \
    if z=$(curl -s 'https://install.zerotier.com/' | gpg); then echo "$z" | bash; fi


RUN apt-get update && apt-cache policy zerotier-one

RUN apt-get install -y zerotier-one=${ZT_VERSION} || \
    apt-get install -y zerotier-one

FROM debian:13-slim
LABEL author="Jonnyan404"
LABEL description="Containerized ZeroTier One for use on CoreOS or other Docker-only Linux hosts."

# ZeroTier relies on UDP port 9993
EXPOSE 9993/udp

RUN apt-get update && apt-get install -y procps iproute2 libssl1.1 libstdc++6 && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /var/lib/zerotier-one
COPY --from=builder /usr/sbin/zerotier-cli /usr/sbin/zerotier-cli
COPY --from=builder /usr/sbin/zerotier-idtool /usr/sbin/zerotier-idtool
COPY --from=builder /usr/sbin/zerotier-one /usr/sbin/zerotier-one

COPY startup.sh /startup.sh

RUN chmod 0755 /startup.sh
ENTRYPOINT ["/startup.sh"]