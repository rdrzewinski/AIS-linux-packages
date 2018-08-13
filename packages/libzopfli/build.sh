TERMUX_PKG_HOMEPAGE=https://github.com/google/zopfli
TERMUX_PKG_DESCRIPTION="New zlib compatible compressor library"
TERMUX_PKG_VERSION=1.0.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=4a570307c37172d894ec4ef93b6e8e3aacc401e78cbcc51cf85b212dbc379a55
TERMUX_PKG_SRCURL=https://github.com/google/zopfli/archive/zopfli-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_post_make_install () {
	make zopflipng
	cp zopfli zopflipng $TERMUX_PREFIX/bin/

	mkdir -p $TERMUX_PREFIX/include/zopfli/
	cp $TERMUX_PKG_SRCDIR/src/zopfli/*h $TERMUX_PREFIX/include/zopfli/
}
