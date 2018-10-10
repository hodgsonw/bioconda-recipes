#!/bin/bash

PKG_NAME=virtool
PKG_VERSION=2.3.2
PKG_BUILDNUM=0

INSTALL=${PREFIX}/share/$PKG_NAME-$PKG_VERSION-$PKG_BUILDNUM

#build client
if [ -e ~/.npm ] ; then
  rm -rf ~/.npm ;
fi

npm install -g yarn
npm install -g webpack@v3.11.0

cd ${SRC_DIR}
cd client
yarn install
webpack --config webpack.production.config.babel.js


#create install folder
mkdir -p $INSTALL

#move from sourcedir to install location
cp -r ${SRC_DIR}/* $INSTALL

#ensure executables are available in the environment's bin folder
ln -s ${INSTALL}/run.py ${PREFIX}/bin/run.py

chmod 0755 ${PREFIX}/bin/run.py
