TERMUX_PKG_HOMEPAGE=https://qalculate.github.io/
TERMUX_PKG_DESCRIPTION="Powerful and easy to use command line calculator"
TERMUX_PKG_VERSION=2.8.1
TERMUX_PKG_SHA256=a901be570bbfad80f1fccb1839ef2d03f6f2b7a02b051df35d5b687a08396105
TERMUX_PKG_SRCURL=https://github.com/Qalculate/libqalculate/releases/download/v$TERMUX_PKG_VERSION/libqalculate-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="libcurl, libmpfr, libxml2, readline, libgmp"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-icu"
