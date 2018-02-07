TERMUX_PKG_HOMEPAGE=https://vifm.info/
TERMUX_PKG_DESCRIPTION="Vifm is an ncurses based file manager with vi like keybindings/modes/options/commands/configuration"
TERMUX_PKG_VERSION=0.9.1
TERMUX_PKG_SHA256=f208cdcd912348df8e18214078ab2455831d05190078ab5af507bd9789ea8b04
TERMUX_PKG_SRCURL=https://github.com/vifm/vifm/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="ncurses, file"

termux_step_pre_configure() {
	autoreconf -if
}
