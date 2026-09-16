#!/usr/bin/env bash
# shellcheck shell=bash
# shellcheck disable=SC2154
# srcdir, pkgdir, pkgname, pkgver, startdir, and _commit are supplied by makepkg.

arch_normalize_source_tree() {
  local expected="${srcdir}/${pkgname}-${pkgver}"
  local -a roots=()

  while IFS= read -r -d '' root; do
    roots+=("$root")
  done < <(find "$srcdir" -mindepth 1 -maxdepth 1 -type d -print0)

  if (( ${#roots[@]} != 1 )); then
    printf 'error: expected exactly one extracted source directory in %s\n' "$srcdir" >&2
    return 1
  fi

  if [[ "${roots[0]}" != "$expected" ]]; then
    [[ ! -e "$expected" ]] || {
      printf 'error: source destination already exists: %s\n' "$expected" >&2
      return 1
    }
    mv -- "${roots[0]}" "$expected"
  fi
}

arch_prepare_waybar_source() {
  local source_root="${srcdir}/${pkgname}-${pkgver}"
  local archive
  archive="$(find "$source_root/packaging/arch" -maxdepth 1 -type f -name 'waybar-*.tar.gz' -print -quit)"
  [[ -n "$archive" ]] || {
    printf 'error: Waybar source archive not found\n' >&2
    return 1
  }

  tar -xzf "$archive" -C "$srcdir"
  patch -Np1 -d "${srcdir}/${_srcdir}" < "$source_root/packaging/arch/immutable-click-coordinates.patch"
}

arch_build_waybar() {
  arch-meson \
    -Dexperimental=true \
    -Dcava=disabled \
    -Dgps=disabled \
    -Dtests=disabled \
    "${srcdir}/${_srcdir}" build
  meson compile -C build
}

arch_package_waybar() {
  local source_root="${srcdir}/${pkgname}-${pkgver}"
  meson install -C build --destdir "${pkgdir}"
  install -Dm644 "${source_root}/LICENSE" \
    "${pkgdir}/usr/share/licenses/${pkgname}/LICENSE"
}
