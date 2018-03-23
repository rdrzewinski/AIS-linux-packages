TERMUX_PKG_HOMEPAGE=https://mariadb.org
TERMUX_PKG_DESCRIPTION="A drop-in replacement for mysql server"
TERMUX_PKG_VERSION=10.2.13
TERMUX_PKG_SHA256=272e7ed9300a05da9e02f8217a01ed3447c4f5a36a12e5233d62cc7c586fc753
TERMUX_PKG_SRCURL=https://ftp.osuosl.org/pub/mariadb/mariadb-$TERMUX_PKG_VERSION/source/mariadb-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBISON_EXECUTABLE=`which bison`
-DBUILD_CONFIG=mysql_release
-DCAT_EXECUTABLE=`which cat`
-DGSSAPI_FOUND=NO
-DENABLED_LOCAL_INFILE=ON
-DHAVE_UCONTEXT_H=False
-DIMPORT_EXECUTABLES=$TERMUX_PKG_HOSTBUILD_DIR/import_executables.cmake
-DINSTALL_LAYOUT=DEB
-DINSTALL_UNIX_ADDRDIR=$TERMUX_PREFIX/tmp/mysqld.sock
-DINSTALL_SBINDIR=$TERMUX_PREFIX/bin
-DMYSQL_DATADIR=$TERMUX_PREFIX/var/lib/mysql
-DPLUGIN_AUTH_GSSAPI_CLIENT=NO
-DPLUGIN_AUTH_GSSAPI=NO
-DPLUGIN_CONNECT=NO
-DPLUGIN_DAEMON_EXAMPLE=NO
-DPLUGIN_EXAMPLE=NO
-DPLUGIN_GSSAPI=NO
-DPLUGIN_ROCKSDB=NO
-DPLUGIN_TOKUDB=NO
-DSTACK_DIRECTION=-1
-DTMPDIR=$TERMUX_PREFIX/tmp
-DWITH_EXTRA_CHARSETS=complex
-DWITH_JEMALLOC=OFF
-DWITH_MARIABACKUP=OFF
-DWITH_PCRE=system
-DWITH_READLINE=OFF
-DWITH_SSL=system
-DWITH_WSREP=False
-DWITH_ZLIB=system
-DWITH_INNODB_BZIP2=OFF
-DWITH_INNODB_LZ4=OFF
-DWITH_INNODB_LZMA=ON
-DWITH_INNODB_LZO=OFF
-DWITH_INNODB_SNAPPY=OFF
-DWITH_UNIT_TESTS=OFF
"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_DEPENDS="liblzma, ncurses, libedit, openssl, pcre, libcrypt, libandroid-support, libandroid-glob"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_CONFLICTS="mysql"
TERMUX_PKG_RM_AFTER_INSTALL="bin/mysqltest*"

termux_step_host_build () {
	termux_setup_cmake
	cmake -G "Unix Makefiles" \
		$TERMUX_PKG_SRCDIR \
		-DWITH_SSL=bundled \
		-DCMAKE_BUILD_TYPE=Release
	make -j $TERMUX_MAKE_PROCESSES import_executables
}

termux_step_pre_configure () {
	CPPFLAGS+=" -Dushort=u_short"

	if [ $TERMUX_ARCH_BITS = 32 ]; then
		CPPFLAGS+=" -D__off64_t_defined -DTERMUX_EXPOSE_FILE_OFFSET64=1"
	fi

	if [ $TERMUX_ARCH = "i686" ]; then
		# Avoid undefined reference to __atomic_load_8:
		CFLAGS+=" -latomic"
	fi
}

termux_step_post_make_install () {
	# files not needed
	rm -r $TERMUX_PREFIX/{mysql-test,sql-bench}
	rm $TERMUX_PREFIX/share/man/man1/mysql-test-run.pl.1
}

termux_step_create_debscripts () {
	echo "if [ ! -e "$TERMUX_PREFIX/var/lib/mysql" ]; then" > postinst
	echo "  echo 'Initializing mysql data directory...'" >> postinst
	echo "  mkdir -p $TERMUX_PREFIX/var/lib/mysql" >> postinst
	echo "  $TERMUX_PREFIX/bin/mysql_install_db --user=\`whoami\` --datadir=$TERMUX_PREFIX/var/lib/mysql --basedir=$TERMUX_PREFIX" >> postinst
	echo "fi" >> postinst
	echo "exit 0" >> postinst
	chmod 0755 postinst
}
