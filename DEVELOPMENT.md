# Development

Argvus Waybar packages Waybar for the Argvus desktop with the
`immutable-click-coordinates.patch` modification.

The upstream project is Alexays/Waybar:

```text
https://github.com/Alexays/Waybar
```

## Requirements

Local package validation requires Arch Linux tooling:

```sh
sudo pacman -S --needed base-devel git
```

The Arch package recipe lives at `packaging/arch/PKGBUILD`.

## Commands

Validate the repository metadata and PKGBUILD syntax:

```sh
make validate
```

Validate that the upstream source downloads and the Argvus patch applies:

```sh
cd packaging/arch
makepkg --nobuild --nodeps --skipchecksums --skippgpcheck
```

Build the package locally:

```sh
cd packaging/arch
makepkg --syncdeps --noconfirm --needed --cleanbuild --clean
```

## Patch

`packaging/arch/immutable-click-coordinates.patch` changes Waybar click command
placeholder substitution so `{x}` and `{y}` use the root-window click position
reported by GTK instead of percentages relative to the clicked widget. Argvus
uses these stable coordinates to anchor shell popups.

## Package Contents

The Arch package installs Waybar's Meson output, including:

```text
/usr/bin/waybar
/etc/xdg/waybar/config.jsonc
/etc/xdg/waybar/style.css
/usr/share/licenses/argvus-waybar/LICENSE
```

The package is architecture-specific, so `makepkg` produces a file named
`argvus-waybar-X.Y.Z-1-x86_64.pkg.tar.zst`.

## Release Flow

1. Tag `vX.Y.Z` and push the tag.
2. Confirm the package workflow builds `argvus-waybar-X.Y.Z-1-x86_64.pkg.tar.zst` and its `.sig`.
3. Confirm the workflow publishes both files to `argvus/packages` under `public/arch/x86_64/` and updates the Arch repository database.

The project does not create GitHub Releases for package distribution. The built
`.pkg.tar.zst` and `.sig` are kept as GitHub Actions artifacts for one day only;
the permanent package copies live in `argvus/packages`.
