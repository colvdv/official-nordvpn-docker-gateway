FROM ubuntu:24.04

# Install dependencies and NordVPN in a single clean layer
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    apt-transport-https \
    ca-certificates \
    iproute2 \
    iptables \
    && wget -qO /etc/apt/trusted.gpg.d/nordvpn_public.asc https://repo.nordvpn.com/gpg/nordvpn_public.asc \
    && echo "deb https://repo.nordvpn.com/deb/nordvpn/debian stable main" > /etc/apt/sources.list.d/nordvpn.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends nordvpn \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# The Anchor: Starts the service, waits for initialization, then stays alive
ENTRYPOINT ["/bin/bash", "-c", "rm -rf /run/nordvpn && mkdir -p /run/nordvpn && /etc/init.d/nordvpn start && sleep 5 && tail -f /dev/null"]
