FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

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

RUN mkdir -p /root/.baresip

COPY baresip_config /root/.baresip/config
COPY baresip_accounts /root/.baresip/accounts

CMD ["bash", "-lc", "baresip -v"]