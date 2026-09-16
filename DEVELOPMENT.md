# Development

This repository packages the upstream Waybar project for the ARGVUS desktop.
The package applies immutable-click-coordinates.patch before building it with Meson.

## Project layout

packaging/arch/ contains ci/PKGBUILD for tagged releases, local/PKGBUILD for
working-tree builds, common/functions.sh for shared behavior, the pinned
upstream Waybar archive, and the ARGVUS patch. tools/sh contains the local
builder and validation scripts. build/ contains ignored local artifacts.

## Checks

On Arch Linux:

    make validate
    make lint
    make build

make build creates the package in build/dist/. Both PKGBUILDs extract the
pinned upstream archive, apply the patch, build with Meson, and install Waybar.

## Package contents

    /usr/bin/waybar
    /etc/xdg/waybar/config.jsonc
    /etc/xdg/waybar/style.css
    /usr/share/licenses/argvus-waybar/LICENSE

The pinned upstream source is Waybar commit
6d60c8e02be67bb85bb9b1ea803f2fbcf0722002.
