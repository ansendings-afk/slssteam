#!/usr/bin/env bash
# Build slssteam-bin and publish it into the pacman repository under docs/.
# Used both by CI and for local rebuilds.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPODIR="$ROOT/docs/x86_64"

cd "$ROOT"

latest="$(
	curl -fsSLI --max-time 60 https://github.com/AceSLS/SLSsteam/releases/latest 2>/dev/null \
		| sed -n 's|^[Ll]ocation: .*/tag/\(.*\)|\1|p' | tr -d '\r' | tail -n1
)"
[ -n "$latest" ] || { echo "Could not determine the latest release tag." >&2; exit 1; }
echo "Latest upstream release: $latest"

mkdir -p "$REPODIR"

# Already published? Nothing to do.
if compgen -G "$REPODIR/slssteam-bin-${latest}-*.pkg.tar.zst" >/dev/null; then
	echo "slssteam-bin $latest is already in the repository."
	exit 0
fi

# Clean previous build artifacts owned by this script.
find "$ROOT" -maxdepth 1 -name 'slssteam-bin-*.pkg.tar.zst' -delete
for stale in src pkg upstream; do
	[ -e "$ROOT/$stale" ] && find "$ROOT/$stale" -depth -delete
done

echo "Building slssteam-bin $latest ..."
makepkg -f --noconfirm

built="$(find "$ROOT" -maxdepth 1 -name "slssteam-bin-${latest}-*.pkg.tar.zst" | head -n1)"
[ -n "$built" ] || { echo "Build produced no package." >&2; exit 1; }

cp -v "$built" "$REPODIR/"

echo "Updating repository database ..."
# Keep only the newest two package files to bound the repository size, then
# index exactly what remains in a single pass.
ls -1t "$REPODIR"/slssteam-bin-*.pkg.tar.zst 2>/dev/null | tail -n +3 | while read -r old; do
	echo "Pruning old package: $old"
	find "$old" -delete
done
repo-add -n -R "$REPODIR/slssteam-bin.db.tar.gz" "$REPODIR"/slssteam-bin-*.pkg.tar.zst

echo "Repository now contains:"
ls -1 "$REPODIR"
