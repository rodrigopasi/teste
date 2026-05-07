FROM debian:bookworm-slim

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

# Debug (deixe por enquanto; remova depois que estabilizar)
RUN ls -la /root/.baresip; \
    echo "----- config -----"; \
    cat /root/.baresip/config; \
    echo "----- accounts -----"; \
    cat /root/.baresip/accounts

# -f força o diretório de configuração (config + accounts)
CMD ["bash", "-lc", "baresip -v -f /root/.baresip"]