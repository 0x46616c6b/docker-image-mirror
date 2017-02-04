BUILD_DIR    = $(CURDIR)/build
PROJECT_NAME = docker-image-mirror
VERSION      = $(shell git describe --tags || echo 0.0.0-dev)
PREFIX       = /usr/local

.PHONY: clean
clean:
	rm -R $(BUILD_DIR)/* || true

.PHONY: prepare
prepare:
	mkdir -p build

.PHONY: install
install:
	cp mirror.sh ${PREFIX}/bin/docker-image-mirror
	chmod 0755 ${PREFIX}/bin/docker-image-mirror

.PHONY: deb
deb:
	make build-deb ARCH=amd64
	make build-deb ARCH=i386
	make build-deb ARCH=arm64
	make build-deb ARCH=armhf

.PHONY: build-deb
build-deb:
	fpm -s dir -t deb \
		--name $(PROJECT_NAME) \
		--version $(VERSION) \
		--package $(BUILD_DIR)/$(PROJECT_NAME)_$(ARCH).deb \
		--maintainer "louis <louis@systemli.org>" \
		--deb-priority optional \
		--force \
 		--deb-compression bzip2 \
		--license "MIT" \
		--deb-no-default-config-files \
		--url https://github.com/0x46616c6b/docker-image-mirror \
		--description "CLI to mirror docker images to a private registry" \
		--architecture $(ARCH) \
		mirror.sh=${PREFIX}/bin/docker-image-mirror
