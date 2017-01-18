#!/bin/sh
#
# (c) vir
#

PKG=wanpipe
VER=7.0.16

function build_package()
{
	DIST=$1
	SUFFIX=${DIST%-*}
	debchange --force-distribution --distribution $DIST -l+$SUFFIX "Ported to $DIST"
	rm -f .dist-version; ./get-version > .dist-version.tmp; mv .dist-version.tmp .dist-version
	dpkg-buildpackage -S -sa -uc -us -rfakeroot
	git checkout -- debian/changelog
}

function upload_package()
{
	pushd ..
	dupload -c -d --to $1 ${PKG}_*.changes
	P=`grep '\.dsc ' *.upload | sed 's/. \(.*\)\.dsc .*/\1/'`
#	echo "name=${P//+/%2B}&queue=$1&start=1" | POST -c "application/x-www-form-urlencoded" http://builder.ctm.ru/control/control.pl | grep -iE '^Build|error'
	rm -f  ${PKG}_*$2*
	popd
}

if [ "$0" != "$PKG-$VER/debian/build.sh" ]
then
	echo "Woops! Read source, luke!";
	exit 13
fi

rm -f ${PKG}_*.dsc ${PKG}_*.changes ${PKG}_*.upload

if [ ! -f ${PKG}_${VER}.orig.tar.gz ]
then
	rm -f ${PKG}[-_]*gz
	wget ftp://ftp.sangoma.com/linux/current_wanpipe/wanpipe-${VER}.tgz
	mv wanpipe-${VER}.tgz ${PKG}_${VER}.orig.tar.gz
fi

if [ ! -f ${PKG}-${VER}/Makefile ]
then
	tar xzf ${PKG}_${VER}.orig.tar.gz
fi
cd ${PKG}-${VER}/

if [ "$1" = "-f" ]
then
	shift
else
	git pull origin master 2>/dev/null | grep '^Already up-to-date\.' && exit 0
fi

#build unstable source package
build_package sid
upload_package vir sid

# build testing source package
#build_package wheezy
#upload_package vir wheezy

# build stable source package
#build_package squeeze
#upload_package vir squeeze

# build old-stable source package
#build_package lenny
#upload_package vir lenny


