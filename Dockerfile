## NOTE: to retain configuration; mount a Docker volume, or use a bind-mount, on /var/lib/zerotier-one
FROM debian:buster-slim as builder

ARG ZT_VERSION=1.14.2

RUN apt-get update && apt-get install -y curl gnupg ca-certificates
# 使用官方提供的 GPG 密钥方法
RUN curl -s 'https://raw.githubusercontent.com/zerotier/ZeroTierOne/main/doc/contact%40zerotier.com.gpg' | gpg --dearmor -o /etc/apt/trusted.gpg.d/zerotier.gpg && \
    echo "deb http://download.zerotier.com/debian/buster buster main" > /etc/apt/sources.list.d/zerotier.list && \
    apt-get update && apt-get install -y zerotier-one=${ZT_VERSION}

FROM debian:buster-slim
ARG ZT_VERSION=1.14.2
LABEL author="Jonnyan404"
LABEL version="${ZT_VERSION}"
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