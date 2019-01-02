TERMUX_PKG_HOMEPAGE=http://www.libpng.org/pub/png/libpng.html
TERMUX_PKG_DESCRIPTION="Official PNG reference library"
TERMUX_PKG_VERSION=1.6.36
TERMUX_PKG_SHA256=eceb924c1fa6b79172fdfd008d335f0e59172a86a66481e09d4089df872aa319
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/libpng-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="bin/libpng-config bin/libpng16-config"
TERMUX_PKG_RM_AFTER_INSTALL="bin/png-fix-itxt bin/pngfix"
