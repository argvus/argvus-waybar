#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd -- "$SCRIPT_DIR/../.." && pwd)"
BUILD_DIR="$ROOT_DIR/build"
ARTIFACTS_DIR="$BUILD_DIR/artifacts"
DIST_DIR="$BUILD_DIR/dist"
PKGBUILD_DIR="$ROOT_DIR/packaging/arch/local"
PKGBUILD="$PKGBUILD_DIR/PKGBUILD"

for command_name in makepkg pacman sha256sum tar awk find; do
  command -v "$command_name" >/dev/null 2>&1 || {
    printf 'error: required command not found: %s\n' "$command_name" >&2
    exit 1
  }
done

read -r pkgname pkgver <<<"$(bash -c 'source "$1"; printf "%s %s" "$pkgname" "$pkgver"' bash "$PKGBUILD")"
build_dependencies="$(bash -c 'source "$1"; printf "%s\n" "${makedepends[@]}"' bash "$PKGBUILD")"
if [[ -n "$build_dependencies" ]]; then
  mapfile -t build_dependencies <<< "$build_dependencies"
  if missing_dependencies="$(pacman -T "${build_dependencies[@]}")"; then
    :
  else
    pacman_status=$?
    if (( pacman_status == 127 )); then
      printf 'error: missing build dependencies for %s:\n%s\n' "$pkgname" "$missing_dependencies" >&2
    else
      printf 'error: pacman could not check build dependencies for %s (exit %s)\n' "$pkgname" "$pacman_status" >&2
    fi
    exit 1
  fi
fi
mkdir -p "$ARTIFACTS_DIR" "$DIST_DIR"
archive="$ARTIFACTS_DIR/${pkgname}-${pkgver}.tar.gz"

tar -czf "$archive" \
  --sort=name --mtime='UTC 1970-01-01' --owner=0 --group=0 --numeric-owner \
  --exclude='./.git' --exclude='./build' --exclude='./dist' \
  --exclude='./tools' --exclude='./packaging/arch/local/src' \
  --exclude='./packaging/arch/local/pkg' --exclude='./packaging/arch/remote/src' \
  --exclude='./packaging/arch/remote/pkg' --exclude='./packaging/arch/*/PKGBUILD.local' \
  --exclude='./packaging/arch/*/*.pkg.tar*' --exclude='./packaging/arch/*/*.tar.gz' \
  --exclude='./*.pkg.tar*' --transform "s#^\./#${pkgname}-${pkgver}/#" \
  -C "$ROOT_DIR" .

cd "$PKGBUILD_DIR"
export BUILDDIR="$ARTIFACTS_DIR" SRCDEST="$ARTIFACTS_DIR" PKGDEST="$DIST_DIR"
generated_pkgbuild="$(mktemp "$PKGBUILD_DIR/.PKGBUILD.local.XXXXXX")"
trap 'rm -f "$generated_pkgbuild"' EXIT
cp "$PKGBUILD" "$generated_pkgbuild"
sha256="$(sha256sum "$archive" | awk '{print $1}')"
# The PKGBUILD lists the local archive first and the pinned upstream Waybar archive second,
# so only the first checksum placeholder is replaced.
sed -i "0,/^sha256sums=('SKIP'/s|^sha256sums=('SKIP'|sha256sums=(\"${sha256}\"|" "$generated_pkgbuild"
grep -q "^sha256sums=(\"${sha256}\"" "$generated_pkgbuild" || {
  printf 'error: could not set the local archive checksum in %s\n' "$generated_pkgbuild" >&2
  exit 1
}
find "$DIST_DIR" -maxdepth 1 -type f -name "${pkgname}-${pkgver}-*.pkg.tar.zst" -delete

if [[ -n "${MAKEPKG_FLAGS:-}" ]]; then
  # shellcheck disable=SC2206
  flags=(${MAKEPKG_FLAGS})
else
  flags=(--nodeps --noconfirm --needed --cleanbuild --force --check)
fi
makepkg -p "$generated_pkgbuild" "${flags[@]}" "$@"

mapfile -t package_files < <(find "$DIST_DIR" -maxdepth 1 -type f \
  -name "${pkgname}-${pkgver}-*.pkg.tar.zst" -print | sort)
(( ${#package_files[@]} == 1 )) || {
  printf 'error: expected exactly one package in %s\n' "$DIST_DIR" >&2
  exit 1
}
command -v namcap >/dev/null 2>&1 && namcap "${package_files[0]}"
printf 'Package created: %s\n' "${package_files[0]}"
