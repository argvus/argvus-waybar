# Arch packaging layout

The package keeps two equivalent
PKGBUILDs with different source inputs:

| Path | Use | Source |
| --- | --- | --- |
| local/PKGBUILD | local working-tree build | generated local repository archive |
| remote/PKGBUILD | tagged release | tagged argvus-waybar repository archive |

Both recipes extract the pinned upstream Waybar archive, apply the
immutable-click-coordinates.patch, build with Meson, and install the same
package contents. Shared behavior lives in common/functions.sh.
