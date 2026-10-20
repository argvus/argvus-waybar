# Development

This repository packages the upstream Waybar project for the ARGVUS desktop.
The package applies immutable-click-coordinates.patch before building it with Meson.

## Project layout

packaging/arch/ contains remote/PKGBUILD for tagged releases, local/PKGBUILD for
working-tree builds, common/functions.sh for shared behavior, and the ARGVUS
patch. makepkg downloads the pinned upstream Waybar archive as a noextract
source. tools/sh contains the local builder and validation scripts. build/
contains ignored local artifacts.

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
6d60c8e02be67bb85bb9b1ea803f2fbcf0722002, with the archive checksum
420c0750092f6ab07fe807e298243dc69ab8ea1224e2f2597a82bd65892d8320.
