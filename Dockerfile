FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/root

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      baresip \
      ca-certificates \
      iproute2 \
      net-tools \
      dnsutils \
      tcpdump; \
    rm -rf /var/lib/apt/lists/*

# Baresip config
RUN mkdir -p /root/.baresip
COPY baresip_config /root/.baresip/config
COPY baresip_accounts /root/.baresip/accounts

# Força o diretório de configuração
CMD ["bash", "-lc", "baresip -v -f /root/.baresip"]