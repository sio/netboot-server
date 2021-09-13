#
# Build ipxe from source
#
FROM debian:bullseye-slim as ipxe-build
ARG IPXE_VERSION=v1.21.1
ADD https://github.com/ipxe/ipxe/archive/$IPXE_VERSION.tar.gz /ipxe.tar.gz
WORKDIR /ipxe
RUN tar zxvf /ipxe.tar.gz --strip-components=1 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        liblzma-dev \
        && \
    make -C src -j$(nproc) \
        bin/ipxe.pxe \
        bin/undionly.kpxe \
        bin-i386-efi/ipxe.efi \
        bin-x86_64-efi/ipxe.efi

#
# Launch dnsmasq server
#
FROM debian:bullseye-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        dnsmasq \
        gettext-base \
        && \
    apt-get clean

COPY --from=ipxe-build /ipxe/src/bin/ipxe.pxe /tftp/ipxe.pxe
COPY --from=ipxe-build /ipxe/src/bin/undionly.kpxe /tftp/undionly.kpxe
COPY --from=ipxe-build /ipxe/src/bin-i386-efi/ipxe.efi /tftp/ipxe-i386.efi
COPY --from=ipxe-build /ipxe/src/bin-x86_64-efi/ipxe.efi /tftp/ipxe.efi
RUN chmod -R a=rX /tftp && \
    cd /tftp && sha256sum * | tee SHA256SUMS

COPY dnsmasq.* /etc/
ENV DNSMASQ_EXCEPT=lo
ENTRYPOINT ["/etc/dnsmasq.entrypoint"]
