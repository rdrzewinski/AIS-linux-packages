TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/PulseAudio
TERMUX_PKG_DESCRIPTION="A featureful, general-purpose sound server - shared libraries"
TERMUX_PKG_VERSION=12.2
TERMUX_PKG_REVISION=6
TERMUX_PKG_SHA256=809668ffc296043779c984f53461c2b3987a45b7a25eb2f0a1d11d9f23ba4055
TERMUX_PKG_SRCURL=https://www.freedesktop.org/software/pulseaudio/releases/pulseaudio-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="libltdl, libsndfile, libandroid-glob, libsoxr"
TERMUX_PKG_BUILD_DEPENDS="libtool"
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="share/vala"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-neon-opt
--disable-alsa
--disable-esound
--disable-glib2
--disable-openssl
--without-caps
--with-database=simple
--disable-memfd
--disable-gsettings
--bindir=$TERMUX_PREFIX/libexec
ax_cv_PTHREAD_PRIO_INHERIT=no
ac_cv_func_posix_madvise=no"
TERMUX_PKG_CONFFILES="etc/pulse/client.conf etc/pulse/daemon.conf etc/pulse/default.pa etc/pulse/system.pa"

termux_step_pre_configure () {
	# Our aaudio sink module needs libaaudio.so from a later android api version:
	local _NDK_ARCHNAME=$TERMUX_ARCH
	if [ "$TERMUX_ARCH" = "aarch64" ]; then
		_NDK_ARCHNAME=arm64
	elif [ "$TERMUX_ARCH" = "i686" ]; then
		_NDK_ARCHNAME=x86
	fi
	mkdir $TERMUX_PKG_TMPDIR/libaaudio
	cp $NDK/platforms/android-26/arch-$_NDK_ARCHNAME/usr/lib*/libaaudio.so \
		$TERMUX_PKG_TMPDIR/libaaudio/
	LDFLAGS+=" -L$TERMUX_PKG_TMPDIR/libaaudio/"

	mkdir $TERMUX_PKG_SRCDIR/src/modules/sles
	cp $TERMUX_PKG_BUILDER_DIR/module-sles-sink.c $TERMUX_PKG_SRCDIR/src/modules/sles
	mkdir $TERMUX_PKG_SRCDIR/src/modules/aaudio
	cp $TERMUX_PKG_BUILDER_DIR/module-aaudio-sink.c $TERMUX_PKG_SRCDIR/src/modules/aaudio

	intltoolize --automake --copy --force

	LDFLAGS+=" -llog -landroid-glob"
}

termux_step_post_make_install () {
	# Some binaries link against these:
	cd $TERMUX_PREFIX/lib
	for lib in pulseaudio/lib*.so* pulse-${TERMUX_PKG_VERSION}/modules/lib*.so*; do
		ln -s -f $lib `basename $lib`
	done

	# Pulseaudio fails to start when it cannot detect any sound hardware
	# so disable hardware detection.
	sed -i $TERMUX_PREFIX/etc/pulse/default.pa \
		-e '/^load-module module-detect$/s/^/#/'
	echo "load-module module-sles-sink" >> $TERMUX_PREFIX/etc/pulse/default.pa
	echo "#load-module module-aaudio-sink" >> $TERMUX_PREFIX/etc/pulse/default.pa

	if [ "$TERMUX_ARCH_BITS" = 32 ]; then
		SYSTEM_LIB=lib
	else
		SYSTEM_LIB=lib64
	fi

	cd $TERMUX_PREFIX/libexec
	for bin in pacat pacmd pactl pasuspender pulseaudio; do
		rm -f ../bin/$bin
		echo "#!$TERMUX_PREFIX/bin/sh" >> ../bin/$bin
		echo "LD_LIBRARY_PATH=/system/$SYSTEM_LIB:/system/vendor/$SYSTEM_LIB:$TERMUX_PREFIX/lib exec $TERMUX_PREFIX/libexec/$bin \"\$@\"" >> ../bin/$bin
		chmod +x ../bin/$bin
	done
}
