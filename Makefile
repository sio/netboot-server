##
## Build
##

DOCKER?=docker
DOCKER_COMPOSE?=docker-compose
DOCKER_IMAGE?=ghcr.io/sio/netboot-server
DOCKER_TAG?=latest
DOCKER_REGISTRY?=ghcr.io
DOCKER_REGISTRY_USER?=sio
DOCKER_REGISTRY_PASS?=

ifeq (master,$(DOCKER_TAG))
DOCKER_TAG=latest
endif

build:
	cd docker && $(DOCKER) build --pull --tag "$(DOCKER_IMAGE):$(DOCKER_TAG)" .

export DOCKER_REGISTRY_PASS
push: build
	echo $$DOCKER_REGISTRY_PASS | $(DOCKER) login -u $(DOCKER_REGISTRY_USER) --password-stdin $(DOCKER_REGISTRY)
	$(DOCKER) push "$(DOCKER_IMAGE):$(DOCKER_TAG)"

serve: serve-pxe serve-http

serve-stop:
	-cd docker && $(DOCKER_COMPOSE) down -t 0
	-cd ipxe && $(DOCKER_COMPOSE) down -t 0

serve-pxe:
	cd docker && $(DOCKER_COMPOSE) up &

serve-http:
	cd ipxe && $(DOCKER_COMPOSE) up &


##
## Manual testing
##

KVM?=/usr/bin/qemu-system-x86_64
KVM_MEMORY?=1G
KVM_CPUS?=2
KVM_BRIDGE?=virbr1
KVM_MONITOR=qemu-monitor.socket
KVM_ARGS?=
KVM_ARGS+=-m $(KVM_MEMORY) -smp $(KVM_CPUS) -boot order=n
KVM_ARGS+=-netdev bridge,id=net0,br=$(KVM_BRIDGE) -device virtio-net-pci,netdev=net0
KVM_ARGS+=-monitor unix:$(KVM_MONITOR),server,nowait
ifdef KVM_NOGRAPHIC
KVM_ARGS+=-nographic
endif

boot: boot-bios
boot-efi: boot-uefi

boot-uefi: KVM_ARGS+=-bios /usr/share/qemu/OVMF.fd

boot-bios boot-uefi: bridge-check
	$(KVM) $(KVM_ARGS)

bridge-check: KVM_BRIDGE_CONF=/etc/qemu/bridge.conf
bridge-check: KVM_BRIDGE_HELPER=/usr/lib/qemu/qemu-bridge-helper
bridge-check:
	@# Check if bridge exists
	@  ip addr show $(KVM_BRIDGE) > /dev/null
	@# Check for setuid bit <https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=691138>
	@  test 4755 -eq $$(stat --printf=%a $(KVM_BRIDGE_HELPER)) \
	|| echo 'Warning: setuid bit not set: chmod 4755 $(KVM_BRIDGE_HELPER)'
	@# Fail if qemu-bridge-helper does not exist at provided path.
	@# Error message will be printed by stat (see above)
	@  test -e $(KVM_BRIDGE_HELPER)
	@# Check for allowed bridge interfaces
	@  grep -qE 'allow\s+$(KVM_BRIDGE)' $(KVM_BRIDGE_CONF) \
	|| echo 'Warning: add line "allow $(KVM_BRIDGE)" to $(KVM_BRIDGE_CONF)'

qemu-monitor:
	socat - UNIX-CONNECT:$(KVM_MONITOR)

tcpdump:
	tcpdump -n -i $(KVM_BRIDGE) port 67 and port 68
