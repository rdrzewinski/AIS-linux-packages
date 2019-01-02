TERMUX_PKG_HOMEPAGE=https://strace.io/
TERMUX_PKG_DESCRIPTION="Debugging utility to monitor system calls and signals received"
TERMUX_PKG_VERSION=4.26
TERMUX_PKG_SHA256=7c4d2ffeef4f7d1cdc71062ca78d1130eb52f947c2fca82f59f6a1183bfa1e1c
TERMUX_PKG_SRCURL=https://github.com/strace/strace/releases/download/v$TERMUX_PKG_VERSION/strace-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_RM_AFTER_INSTALL=bin/strace-graph # This is a perl script
# Without st_cv_m32_mpers=no the build fails if gawk is installed.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
st_cv_m32_mpers=no
--enable-mpers=no
--without-libdw
"
