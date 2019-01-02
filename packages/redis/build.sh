TERMUX_PKG_HOMEPAGE=https://redis.io/
TERMUX_PKG_DESCRIPTION="In-memory data structure store used as a database, cache and message broker"
TERMUX_PKG_VERSION=5.0.3
TERMUX_PKG_SHA256=e290b4ddf817b26254a74d5d564095b11f9cd20d8f165459efa53eb63cd93e02
TERMUX_PKG_SRCURL=http://download.redis.io/releases/redis-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_CONFFILES="etc/redis.conf"

termux_step_pre_configure() {
    export PREFIX=$TERMUX_PREFIX
    export USE_JEMALLOC=no

    LDFLAGS+=" -llog"

    if [ $TERMUX_ARCH = "i686" ]; then
	    sed -i 's/FINAL_LIBS=-lm/FINAL_LIBS=-lm -latomic/' $TERMUX_PKG_SRCDIR/src/Makefile
    fi
}

termux_step_post_make_install() {
    cp $TERMUX_PKG_SRCDIR/redis.conf $TERMUX_PREFIX/etc/redis.conf
}
