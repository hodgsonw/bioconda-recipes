#!/bin/bash

PKG_NAME=virtool
PKG_VERSION=2.3.2
PKG_BUILDNUM=0

INSTALL=${PREFIX}/share/$PKG_NAME-$PKG_VERSION-$PKG_BUILDNUM

#build client
npm --production --loglevel warn install -g yarn webpack@v3.11.0

cd ${SRC_DIR}
cd client
yarn install
webpack --config webpack.production.config.babel.js

#remove build dependencies
npm uninstall -g webpack yarn 

#create install folder
mkdir -p $INSTALL

#configure mongodb for virtool
mkdir -p $INSTALL/mongo
mkdir -p $INSTALL/virtooldb

#conda removes empty folders from packages. this keeps the virtooldb folder present for mongo
touch $INSTALL/virtooldb/.deleteMe


#set up mongodb config
cat << EOF >$INSTALL/mongo/mongo.conf
processManagement:
   fork: true
   pidFilePath: ./virtooldb.pid
net:
   bindIp: localhost
   port: 27017
storage:
   dbPath: ../virtooldb/
systemLog:
   destination: file
   path: ./virtooldb.log
   logAppend: true
storage:
   journal:
       enabled: true
EOF

#move from sourcedir to install location
cp -r ${SRC_DIR}/* $INSTALL

#ensure executables are available in the environment's bin folder
ln -s ${INSTALL}/run.py ${PREFIX}/bin/run.py

