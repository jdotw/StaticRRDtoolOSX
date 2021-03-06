#!/bin/bash

echo "----------------------------------------------------------------------"
echo "NOTE: This script does use 'sudo make install' to perform install"
echo "      steps that need authentication. You will be prompted to"
echo "      enter your password during the build"
echo ""
echo "      The only thing that is installed outside of this self-contained"
echo "      build are some config files needed by fontconfig and pango. "
echo "      These will go into /usr/local/etc"
echo "----------------------------------------------------------------------"
sleep 4

if [ -f "result/rrdtool" ]; then
  echo "Cheated and used cache!"
  cp result/rrdtool debian/lcrrdtool/usr/bin/lcrrdtool
  cp result/rrdupdate debian/lcrrdtool/usr/bin/lcrrdupdate
  cp result/rrdcached debian/lcrrdtool/usr/bin/lcrrdcached
  exit 0
fi

PKGCONFIG=pkg-config-0.25
LIBICONV=libiconv-1.13.1
LIBPNG=libpng-1.4.4
PIXMAN=pixman-0.19.6
FONTCONFIG=fontconfig-2.8.0
POPPLER=poppler-0.14.4
CAIRO=cairo-1.10.0
EXPAT=expat-2.0.1
GETTEXT=gettext-0.18.1.1
GLIB=glib-2.26.0
PANGO=pango-1.28.3
RRDTOOL=rrdtool-1.4.4
LIBXML=libxml2-2.7.7
FREETYPE=freetype-2.4.3

STAGE=$PWD/stage

PKG_CONFIG=$STAGE/bin/pkg-config
PKG_CONFIG_PATH=$STAGE/lib/pkgconfig  
PATH=$PATH:$STAGE/bin
CFLAGS=""
LDFLAGS="-L$STAGE/lib" 

CONFIGURE_FLAGS="--prefix=$STAGE --enable-static --sysconfdir=/usr/etc"

#
# Staging
#

rm -rf $STAGE
mkdir -p $STAGE

# 
# Build 
#

# pkg-config
tar zxvf $PKGCONFIG.tar.gz
cd $PKGCONFIG
CFLAGS=$CFLAGS \
CXXFLAGS=$CFLAGS \
LDFLAGS=$LDFLAGS \
PKG_CONFIG=$PKG_CONFIG \
PKG_CONFIG_PATH=$PKG_CONFIG_PATH \
./configure $CONFIGURE_FLAGS && make && echo "Using sudo to install, you may be asked for your password" && sudo make install
if [ $? -ne 0 ]; then
  exit 1
fi
cd ..
rm -rf $PKGCONFIG

# libiconv
tar zxvf $LIBICONV.tar.gz
cd $LIBICONV
CFLAGS=$CFLAGS \
CXXFLAGS=$CFLAGS \
LDFLAGS=$LDFLAGS \
PKG_CONFIG=$PKG_CONFIG \
PKG_CONFIG_PATH=$PKG_CONFIG_PATH \
./configure $CONFIGURE_FLAGS && make && echo "Using sudo to install, you may be asked for your password" && sudo make install
if [ $? -ne 0 ]; then
  exit 1
fi
cd ..
rm -rf $LIBICONV

# libpng
tar zxvf $LIBPNG.tar.gz
cd $LIBPNG
CFLAGS=$CFLAGS \
CXXFLAGS=$CFLAGS \
LDFLAGS=$LDFLAGS \
PKG_CONFIG=$PKG_CONFIG \
PKG_CONFIG_PATH=$PKG_CONFIG_PATH \
./configure $CONFIGURE_FLAGS && make && echo "Using sudo to install, you may be asked for your password" && sudo make install
if [ $? -ne 0 ]; then
  exit 1
fi
cd ..
rm -rf $LIBPNG

# pixman
tar zxvf $PIXMAN.tar.gz
cd $PIXMAN
CFLAGS=$CFLAGS \
CXXFLAGS=$CFLAGS \
LDFLAGS=$LDFLAGS \
PKG_CONFIG=$PKG_CONFIG \
PKG_CONFIG_PATH=$PKG_CONFIG_PATH \
./configure $CONFIGURE_FLAGS && make && echo "Using sudo to install, you may be asked for your password" && sudo make install
if [ $? -ne 0 ]; then
  exit 1
fi
cd ..
rm -rf $PIXMAN

# freetype
tar zxvf $FREETYPE.tar.gz
cd $FREETYPE
CFLAGS=$CFLAGS \
CXXFLAGS=$CFLAGS \
LDFLAGS=$LDFLAGS \
PKG_CONFIG=$PKG_CONFIG \
PKG_CONFIG_PATH=$PKG_CONFIG_PATH \
./configure --prefix=$STAGE --enable-static && make && echo "Using sudo to install, you may be asked for your password" && sudo make install
if [ $? -ne 0 ]; then
  exit 1
fi
cd ..
rm -rf $FREETYPE

# fontconfig
tar zxvf $FONTCONFIG.tar.gz
cd $FONTCONFIG
sed -i '' -e 's/use_iconv=1/use_iconv=0/g' configure.in
libtoolize --force
aclocal
autoconf
automake
CFLAGS=$CFLAGS \
CXXFLAGS=$CFLAGS \
LDFLAGS="$LDFLAGS" \
PKG_CONFIG=$PKG_CONFIG \
PKG_CONFIG_PATH=$PKG_CONFIG_PATH \
LIBXML2_CFLAGS="-I/usr/include/libxml2" \
LIBXML2_LIBS="-lxml2" \
./configure $CONFIGURE_FLAGS --with-freetype-config=$STAGE/bin/freetype-config && make && echo "Using sudo to install, you may be asked for your password" && sudo make install
if [ $? -ne 0 ]; then
  exit 1
fi
cd ..
rm -rf $FONTCONFIG

# poppler
tar zxvf $POPPLER.tar.gz
cd $POPPLER
CFLAGS=$CFLAGS \
CXXFLAGS=$CFLAGS \
LDFLAGS=$LDFLAGS \
PKG_CONFIG=$PKG_CONFIG \
PKG_CONFIG_PATH=$PKG_CONFIG_PATH \
./configure $CONFIGURE_FLAGS --disable-poppler-qt --disable-poppler-cpp --disable-poppler-qt4 --enable-xpdf-headers --enable-zlib --disable-gtk-test --without-x
if [ $? -ne 0 ]; then
  exit 1
fi
#sed -i '' -e "s/DEFAULT_INCLUDES \=/DEFAULT_INCLUDES \= -I..\/..\/stage\/include/" cpp/Makefile
#if [ $? -ne 0 ]; then
#  exit 1
#fi
make && echo "Using sudo to install, you may be asked for your password" && sudo make install
if [ $? -ne 0 ]; then
  exit 1
fi
cd ..
rm -rf $POPPLER

# cairo
tar zxvf $CAIRO.tar.gz
cd $CAIRO
CFLAGS=$CFLAGS \
CXXFLAGS=$CFLAGS \
LDFLAGS=$LDFLAGS \
PKG_CONFIG=$PKG_CONFIG \
PKG_CONFIG_PATH=$PKG_CONFIG_PATH \
./configure $CONFIGURE_FLAGS --enable-static --enable-xlib=no --enable-xlib-render=no --enable-win32=no && make && echo "Using sudo to install, you may be asked for your password" && sudo make install
if [ $? -ne 0 ]; then
  exit 1
fi
cd ..
rm -rf $CAIRO

# expat
tar zxvf $EXPAT.tar.gz
cd $EXPAT
CFLAGS=$CFLAGS \
CXXFLAGS=$CFLAGS \
LDFLAGS=$LDFLAGS \
PKG_CONFIG=$PKG_CONFIG \
PKG_CONFIG_PATH=$PKG_CONFIG_PATH \
./configure $CONFIGURE_FLAGS && make && echo "Using sudo to install, you may be asked for your password" && sudo make install
if [ $? -ne 0 ]; then
  exit 1
fi
cd ..
rm -rf $EXPAT

# gettext
tar zxvf $GETTEXT.tar.gz
cd $GETTEXT
CFLAGS=$CFLAGS \
CXXFLAGS=$CFLAGS \
LDFLAGS=$LDFLAGS \
PKG_CONFIG=$PKG_CONFIG \
PKG_CONFIG_PATH=$PKG_CONFIG_PATH \
./configure $CONFIGURE_FLAGS && make && echo "Using sudo to install, you may be asked for your password" && sudo make install
if [ $? -ne 0 ]; then
  exit 1
fi
cd ..
rm -rf $GETTEXT

# libxml
tar zxvf $LIBXML.tar.gz
cd $LIBXML
CFLAGS=$CFLAGS \
CXXFLAGS=$CFLAGS \
LDFLAGS=$LDFLAGS \
PKG_CONFIG=$PKG_CONFIG \
PKG_CONFIG_PATH=$PKG_CONFIG_PATH \
./configure $CONFIGURE_FLAGS && make && echo "Using sudo to install, you may be asked for your password" && sudo make install
if [ $? -ne 0 ]; then
  exit 1
fi
cd ..
rm -rf $LIBXML

# glib
tar zxvf $GLIB.tar.gz
cd $GLIB
CFLAGS=$CFLAGS \
CXXFLAGS=$CFLAGS \
LDFLAGS=$LDFLAGS \
PKG_CONFIG=$PKG_CONFIG \
PKG_CONFIG_PATH=$PKG_CONFIG_PATH \
./configure $CONFIGURE_FLAGS && make && echo "Using sudo to install, you may be asked for your password" && sudo make install
if [ $? -ne 0 ]; then
  exit 1
fi
cd ..
rm -rf $GLIB

# pango
tar zxvf $PANGO.tar.gz
cd $PANGO
sed -i '' -e 's/have_atsui=true/have_atsui=false/g' configure
CFLAGS=$CFLAGS \
CXXFLAGS=$CFLAGS \
LDFLAGS=$LDFLAGS \
PKG_CONFIG=$PKG_CONFIG \
PKG_CONFIG_PATH=$PKG_CONFIG_PATH \
./configure $CONFIGURE_FLAGS --with-dynamic-modules=no --with-included-modules=basic-fc --enable-static --without-x && make && echo "Using sudo to install, you may be asked for your password" && sudo make install
if [ $? -ne 0 ]; then
  exit 1
fi
cd ..
rm -rf $PANGO

# rrdtool
rm -rf $RRDTOOL
tar zxvf $RRDTOOL.tar.gz
cd $RRDTOOL
CFLAGS=$CFLAGS \
CXXFLAGS=$CFLAGS \
LDFLAGS="$LDFLAGS -lpthread" \
PKG_CONFIG=$PKG_CONFIG \
PKG_CONFIG_PATH=$PKG_CONFIG_PATH \
./configure $CONFIGURE_FLAGS --disable-rrdcgi --enable-static-programs --disable-pthread\
  --disable-libdbi --disable-perl --disable-ruby --disable-lua --disable-tcl \
  PKGCONFIG=$PKG_CONFIG && make && echo "Using sudo to install, you may be asked for your password" && sudo make install
if [ $? -ne 0 ]; then
  exit 1
fi
cd ..
rm -rf $RRDTOOL

#
# Get Result
#

rm -rf result
mkdir -p result
cp $STAGE/bin/rrd* result
mkdir -p debian/lcrrdtool/usr/bin
cp $STAGE/bin/rrdtool debian/lcrrdtool/usr/bin/lcrrdtool
cp $STAGE/bin/rrdupdate debian/lcrrdtool/usr/bin/lcrrdupdate
cp $STAGE/bin/rrdcached debian/lcrrdtool/usr/bin/lcrrdcached

echo "Cleaning up the staging area, you may be asked for your password."
sudo rm -rf $STAGE

echo "----------------------------------------------------------------------"
echo "The static build of RRDtool has completed and the rrdtool, rrdupdate"
echo "and rrdcached binaries can be found in the 'result' directory"
echo "----------------------------------------------------------------------"
