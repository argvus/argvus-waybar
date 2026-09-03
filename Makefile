PREFIX ?= /usr
DESTDIR ?=

.DEFAULT_GOAL := help

.PHONY: help validate validate-pkgbuild release-archive build clean

help:
	@echo "Available targets:"
	@echo "  make build"
	@echo "  make validate"
	@echo "  make validate-pkgbuild"
	@echo "  make release-archive"

validate:
	test -f packaging/arch/PKGBUILD
	test -f packaging/arch/immutable-click-coordinates.patch

validate-pkgbuild: validate
	@if command -v makepkg >/dev/null 2>&1; then \
		cd packaging/arch && makepkg --printsrcinfo >/dev/null; \
	else \
		echo "makepkg not found; skipping PKGBUILD syntax validation"; \
	fi

release-archive:
	mkdir -p .release
	git archive --format=tar.gz --prefix="argvus-waybar-$$(git rev-parse --short HEAD)/" \
		--output=".release/argvus-waybar-$$(git rev-parse --short HEAD).tar.gz" HEAD

.PHONY: build

build:
	@tools/build-local-package.sh

clean:
	rm -f packaging/arch/*.zst packaging/arch/*.tar.gz
