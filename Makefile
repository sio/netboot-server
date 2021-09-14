##
## Build
##

DOCKER?=docker
DOCKER_TAG?=ghcr.io/sio/netboot-server:latest
DOCKER_REGISTRY?=ghcr.io
DOCKER_REGISTRY_USER?=sio
DOCKER_REGISTRY_PASS?=

build:
	cd docker && $(DOCKER) build --tag "$(DOCKER_TAG)" .

push: export DOCKER_REGISTRY_PASS
push: build
	echo $$DOCKER_REGISTRY_PASS | $(DOCKER) login -u $(DOCKER_REGISTRY_USER) --password-stdin $(DOCKER_REGISTRY)
	$(DOCKER) push "$(DOCKER_TAG)"

serve:
	$(DOCKER) run -it "$(DOCKER_TAG)"



##
## Manual testing
##
## Configure the bridge first:
## export KVM_ARGS='-netdev bridge,id=n1,br=virbr1 -device virtio-net-pci,netdev=n1'

KVM?=/usr/bin/qemu-system-x86_64
KVM_MEMORY?=1G
KVM_CPUS?=2
KVM_BRIDGE?=virbr1
KVM_ARGS?=
KVM_ARGS+=-m $(KVM_MEMORY) -smp $(KVM_CPUS) -boot order=n
KVM_ARGS+=-netdev bridge,id=net0,br=$(KVM_BRIDGE) -device virtio-net-pci,netdev=net0

boot: boot-bios
boot-efi: boot-uefi

boot-uefi: KVM_ARGS+=-bios /usr/share/qemu/OVMF.fd

boot-bios boot-uefi: bridge-check
	$(KVM) $(KVM_ARGS)

bridge-check: KVM_BRIDGE_CONF=/etc/qemu/bridge.conf
bridge-check:
	@  grep -qE 'allow\s+$(KVM_BRIDGE)' $(KVM_BRIDGE_CONF) \
	|| echo 'Warning: add line "allow $(KVM_BRIDGE)" to $(KVM_BRIDGE_CONF)'
