# Docker image for network boot server

## Overview

This container launches dnsmasq in proxyDHCP mode with TFTP server enabled.
iPXE images are served by said TFTP server. iPXE binaries are built from
upstream at each Docker image rebuild.

dnsmasq configuration is templated with environment variables at startup via
envsubst. The required variables are:

- `IPXE_SERVER_IP`
- `IPXE_SCRIPT_URL`

## Network integration

PXE server has to actually be a part of the network to which PXE clients will
connect. By default Docker hides all containers in a separate network.
Exposing the container to the host network can be achieved either with
`ipvlan`/`macvlan` bridge or by using `host` network directly.

Sample compose files are provided for both scenarios

## Firewall configuration

When using with `network_mode: host` the following ports need to be open on
host
([docs](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/mt670791(v=ws.11)))

- `udp/67` - BOOTP server
- `udp/68` - BOOTP client
- `udp/69` - TFTP server
- `udp/4011` - PXE server
