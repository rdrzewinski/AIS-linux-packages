TERMUX_PKG_HOMEPAGE=https://www.wireguard.com
TERMUX_PKG_DESCRIPTION="Tools for the WireGuard secure network tunnel"
TERMUX_PKG_VERSION=0.0.20180809
TERMUX_PKG_SHA256=3e351c42d22de427713f1da06d21189c5896a694a66cf19233a7c33295676f19
TERMUX_PKG_SRCURL=https://git.zx2c4.com/WireGuard/snapshot/WireGuard-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_DEPENDS="libmnl, tsu"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_MAKE_ARGS=" -C src/tools WITH_BASHCOMPLETION=yes WITH_WGQUICK=no WITH_SYSTEMDUNITS=no"

termux_step_post_make_install () {
    cd src/tools/wg-quick
    $CC $CFLAGS -DWG_CONFIG_SEARCH_PATHS="\"$TERMUX_ANDROID_HOME/.wireguard $TERMUX_PREFIX/etc/wireguard /data/misc/wireguard /data/data/com.wireguard.android/files\"" -o wg-quick android.c
    install -m 0755 wg-quick $TERMUX_PREFIX/bin
}
