TERMUX_PKG_HOMEPAGE=https://www.gnupg.org/related_software/libassuan/
TERMUX_PKG_DESCRIPTION="Library implementing the Assuan IPC protocol used between most newer GnuPG components"
TERMUX_PKG_VERSION=2.5.2
TERMUX_PKG_SHA256=986b1bf277e375f7a960450fbb8ffbd45294d06598916ad4ebf79aee0cb788e7
TERMUX_PKG_SRCURL=https://www.gnupg.org/ftp/gcrypt/libassuan/libassuan-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="bin/libassuan-config"
TERMUX_PKG_DEPENDS="libgpg-error"
