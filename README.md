# LAN boot server

## Components

### [docker]/ - Docker image for the PXE server

PXE boot server consists of multiple components (ProxyDHCP, TFTP, boot
program) which in turn require some non-trivial configuration. To simplify the
deployment and to ensure reproducibility all required components are packaged
into a single container image: <https://ghcr.io/sio/netboot-server>

Software packaged into this container:

- [dnsmasq] provides proxyDHCP and TFTP server
- [iPXE] is used as initial boot program. In turn it enables booting via wide
  variety of network protocols: HTTP, FTP, NFS, etc.

[dnsmasq]: https://thekelleys.org.uk/dnsmasq/doc.html
[iPXE]: https://ipxe.org

### [ipxe]/ - Sample boot scripts for iPXE environment

Boot server provided by Docker image needs to point to iPXE scripts to
actually boot anything. This directory provides a simple boot script that can
be used as a starting point for your own deployments.

[docker]: docker/
[ipxe]: ipxe/


## Useful links

- [Boot server at Netsoc (TCD’s Internet Society)](https://docs.netsoc.ie/infrastructure/provisioning/boot/)
- [Dnsmasq proxyDHCP (FOG project)](https://wiki.fogproject.org/wiki/index.php?title=ProxyDHCP_with_dnsmasq)
- [Dnsmasq conditional PXE tagging](https://gist.github.com/NiKiZe/5c181471b96ac37a069af0a76688944d)
- [IPvlan networks in Docker](https://docs.docker.com/network/ipvlan/)
- [Dockerized PXE server](https://github.com/ferrarimarco/docker-pxe)
