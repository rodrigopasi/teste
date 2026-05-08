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

# DIAGNÓSTICO: procurar módulos do baresip (.so) e caminhos possíveis
RUN set -eux; \
    echo "=== which baresip ==="; \
    which baresip || true; \
    echo "=== baresip version ==="; \
    baresip -V || true; \
    echo "=== list /usr/lib* baresip dirs ==="; \
    ls -la /usr/lib 2>/dev/null || true; \
    ls -la /usr/lib/*/baresip 2>/dev/null || true; \
    ls -la /usr/lib/*/baresip/modules 2>/dev/null || true; \
    ls -la /usr/lib/baresip 2>/dev/null || true; \
    ls -la /usr/lib/baresip/modules 2>/dev/null || true; \
    echo "=== find baresip *.so (first 200) ==="; \
    find /usr -type f -name "*.so" -path "*baresip*" 2>/dev/null | head -n 200 || true; \
    echo "=== dpkg -L baresip (if available) ==="; \
    dpkg -L baresip 2>/dev/null | head -n 200 || true

# Baresip config
RUN mkdir -p /root/.baresip
COPY baresip_config /root/.baresip/config
COPY baresip_accounts /root/.baresip/accounts

CMD ["bash", "-lc", "baresip -v -f /root/.baresip"]