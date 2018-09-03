TERMUX_PKG_HOMEPAGE=https://www.imagemagick.org/
TERMUX_PKG_DESCRIPTION="Suite to create, edit, compose, or convert images in a variety of formats"
TERMUX_PKG_VERSION=7.0.8.10
TERMUX_PKG_SHA256=119f99e7849805741fbf0a7890bae0b0a6530fdab35dd3f39185b2dddba272f8
local _download_version=`echo $TERMUX_PKG_VERSION | sed 's/\(.*\)\./\1-/'`
TERMUX_PKG_SRCURL=https://github.com/ImageMagick/ImageMagick/archive/${_download_version}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-largefile
--without-x
--without-gvc
--with-magick-plus-plus=no
--with-bzlib=no
--with-xml=yes
--with-lzma
--disable-openmp
ac_cv_func_ftime=no
ac_cv_header_complex_h=no
"
TERMUX_PKG_RM_AFTER_INSTALL="
bin/Magick-config
bin/MagickCore-config
bin/MagickWand-config
bin/Wand-config
share/ImageMagick-7/francais.xml
share/man/man1/Magick-config.1
share/man/man1/MagickCore-config.1
share/man/man1/MagickWand-config.1
share/man/man1/Wand-config.1
"
TERMUX_PKG_DEPENDS="fftw, pango, glib, libbz2, libjpeg-turbo, liblzma, libpng, libtiff, libxml2, openjpeg, littlecms, libwebp"

termux_step_pre_configure() {
	if [ $TERMUX_ARCH = "i686" ]; then
		# Avoid "libMagickCore-7.Q16HDRI.so: error: undefined reference to '__atomic_load'":
		LDFLAGS+=" -latomic"
	fi
}
