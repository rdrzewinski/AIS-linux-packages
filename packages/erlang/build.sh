TERMUX_PKG_HOMEPAGE=https://www.erlang.org/
TERMUX_PKG_DESCRIPTION="General-purpose concurrent functional programming language"
TERMUX_PKG_VERSION=21.2.2
TERMUX_PKG_SHA256=41b1c3a8343218157a683776e71d80a05ac4eb4019a90a760846608d78817690
TERMUX_PKG_SRCURL=https://github.com/erlang/otp/archive/OTP-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="openssl, ncurses, libutil"
TERMUX_PKG_HOSTBUILD="yes"
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-javac --with-ssl=${TERMUX_PREFIX} --with-termcap"
TERMUX_PKG_EXTRA_MAKE_ARGS="noboot"
TERMUX_PKG_KEEP_STATIC_LIBRARIES="true"
TERMUX_PKG_NO_DEVELSPLIT="yes"

termux_step_post_extract_package() {
	# We need a host build every time:
	rm -Rf "$TERMUX_PKG_HOSTBUILD_DIR"
	./otp_build autoconf
}

termux_step_host_build () {
	cd $TERMUX_PKG_SRCDIR
	./configure --enable-bootstrap-only
	make -j "$TERMUX_MAKE_PROCESSES"
}

termux_step_pre_configure () {
	(cd erts && autoreconf)

	# liblog is needed for syslog usage:
	LDFLAGS+=" -llog"
	# Put binaries built in termux_step_host_build at start of PATH:
	cp bin/*/* $TERMUX_PKG_SRCDIR/bootstrap/bin
	export PATH="$TERMUX_PKG_SRCDIR/bootstrap/bin:$PATH"
}
