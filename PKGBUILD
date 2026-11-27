# Maintainer: ansendings-afk
# Repackages the upstream SLSsteam Arch release binary into slssteam-bin.
# pkgver is resolved from GitHub's release redirect, which needs no API token
# and is not subject to the unauthenticated API rate limit.

pkgname=slssteam-bin
_upstream="AceSLS/SLSsteam"
_asset="SLSsteam-Arch-release-x86_64.pkg.tar.zst"

_tag="$(curl -fsSLI --max-time 60 "https://github.com/${_upstream}/releases/latest" 2>/dev/null \
        | sed -n 's|^[Ll]ocation: .*/tag/\(.*\)|\1|p' | tr -d '\r' | tail -n1)"

pkgver="${_tag}"
pkgrel=1
pkgdesc="Steamclient Mod (upstream prebuilt binary)"
arch=("x86_64")
url="https://github.com/${_upstream}"
license=("AGPL-3.0-only")

depends=("steam"
         "curl"
         "dbus"
         "libstdc++"
         "glibc"
         "systemd-libs"
         "dotnet-runtime")

optdepends=("steam-native-runtime")

provides=("slssteam")
conflicts=("slssteam" "slssteam-git")

# The upstream ticket grabber is a self-contained binary that makepkg's
# stripper would corrupt, so stripping stays off.
options=(!strip)

source=("${_asset}::https://github.com/${_upstream}/releases/latest/download/${_asset}")
sha256sums=("SKIP")

package() {
	# Unpack the upstream pacman package into a scratch directory and re-emit
	# its payload. makepkg writes fresh metadata, so the upstream .PKGINFO,
	# .BUILDINFO and .MTREE are intentionally not copied.
	local upstream="$srcdir/upstream"
	mkdir -p "$upstream"
	bsdtar -xf "$srcdir/${_asset}" -C "$upstream"
	cp -a "$upstream/usr" "$pkgdir/"
}
