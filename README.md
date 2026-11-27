# slssteam

Pacman repository for `slssteam-bin`, repackaging the upstream prebuilt
Arch release of [SLSsteam](https://github.com/AceSLS/SLSsteam).

## Use it

```ini
[slssteam]
SigLevel = Optional TrustAll
Server = https://ansendings-afk.github.io/slssteam/$arch
```

Put that in `/etc/pacman.d/slssteam.conf`, add
`Include = /etc/pacman.d/slssteam.conf` to `/etc/pacman.conf`, then:

```bash
sudo pacman -Syu
sudo pacman -S slssteam-bin
```

## How it works

`.github/workflows/build.yml` runs every six hours inside an `archlinux`
container. `build.sh` resolves the newest upstream release tag, builds
`PKGBUILD` with `makepkg`, adds the result to `docs/x86_64` with `repo-add`,
and the workflow commits the updated repository back. GitHub Pages serves
`docs/`, so clients pick the change up on their next `pacman -Syu`.

The package is unsigned (`SigLevel = Optional TrustAll`); integrity relies on
GitHub's HTTPS. Upstream publishes no signed archives to verify against.
