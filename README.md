# vfonov/minc

A [Homebrew](https://brew.sh) tap with formulae for the
[MINC](https://github.com/BIC-MNI/minc-toolkit-v2) medical image processing
toolkit on macOS.

## Install

```sh
brew tap vfonov/minc
brew install --build-from-source minc-toolkit-v2
```

`--build-from-source` is required: there is no pre-built bottle.

## Formulae

### `minc-toolkit-v2`

A full source build of minc-toolkit-v2 (pinned to the `develop-1.9.18` branch
tip): libminc, minctools, bicpl, EBTKS, mni_autoreg, N3, classify, BEaST, the
visual tools (Display, Register, …) plus the ITK 4.14 fork, ANTs, Convert3D,
Elastix and ABC.

The formula is self-contained: every third-party tarball the superbuild
normally downloads at configure time (HDF5, NetCDF, ITK, GSL, FFTW, zlib-ng,
JPEG, OpenJPEG, NIFTI, liblbfgs, Convert3D, Elastix, ABC) is declared as a
Homebrew `resource` and staged into the build's package cache, so the install
runs without network access. OpenBLAS, libarchive, libpng and glfw come from
Homebrew.

**Expect a long, disk-heavy compile** — ITK plus ANTs/Elastix/Convert3D are
built from source.

After installation, source the environment before using the tools (it sets
`PATH`, `PERL5LIB`, `DYLD_LIBRARY_PATH`, `MNI_DATAPATH`, `MINC_FORCE_V2`, …):

```sh
source "$(brew --prefix)/opt/minc-toolkit-v2/minc-toolkit-config.sh"
```

## Updating the pinned revision

`minc-toolkit-v2` tracks the moving `develop-1.9.18` branch via a pinned
`revision:`. To follow a newer commit, update `revision:` in
`Formula/minc-toolkit-v2.rb` (and any changed `resource` sha256s), then
`brew reinstall --build-from-source minc-toolkit-v2`.

## License

The formulae in this tap are released under the BSD-2-Clause license. The
packaged software has its own licenses (minc-toolkit-v2 is GPL-3.0).
