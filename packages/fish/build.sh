TERMUX_PKG_HOMEPAGE=https://fishshell.com/
TERMUX_PKG_DESCRIPTION="Shell geared towards interactive use"
TERMUX_PKG_VERSION=3.0.0
TERMUX_PKG_SHA256=ea9dd3614bb0346829ce7319437c6a93e3e1dfde3b7f6a469b543b0d2c68f2cf
TERMUX_PKG_SRCURL=https://github.com/fish-shell/fish-shell/releases/download/$TERMUX_PKG_VERSION/fish-${TERMUX_PKG_VERSION}.tar.gz
# fish calls 'tput' from ncurses-utils, at least when cancelling (Ctrl+C) a command line.
# man is needed since fish calls apropos during command completion.
TERMUX_PKG_DEPENDS="ncurses, libandroid-support, ncurses-utils, man, bc, pcre2"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_file__proc_self_stat=yes
--without-included-pcre2
"

termux_step_pre_configure() {
	CXXFLAGS+=" $CPPFLAGS"
}

termux_step_post_make_install () {
	cat >> $TERMUX_PREFIX/etc/fish/config.fish <<HERE

function __fish_command_not_found_handler --on-event fish_command_not_found
	$TERMUX_PREFIX/libexec/termux/command-not-found \$argv[1]
end
HERE
}
