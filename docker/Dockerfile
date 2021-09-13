FROM debian:bullseye-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        dnsmasq \
        gettext-base \
        && \
    apt-get clean

RUN mkdir -p /tftp && \
    curl -L https://boot.ipxe.org/ipxe.efi -o /tftp/ipxe.efi && \
    curl -L https://boot.ipxe.org/undionly.kpxe -o /tftp/undionly.kpxe && \
    chmod -R a=rX /tftp && \
    cd /tftp && sha256sum * | tee SHA256SUMS

COPY dnsmasq.* /etc/
ENV DNSMASQ_EXCEPT=lo
ENTRYPOINT ["/etc/dnsmasq.entrypoint"]
