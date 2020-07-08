#!/usr/bin/env bash
set -e

mkdir -p $(pwd)/output/
rm -rf $(pwd)/output/*

export BoostDir=$(pwd)/lib/boost_1_73_0/
if [ ! -d "${OPENSSL_DIR}" ]; then
    (
        mkdir -p $(pwd)/lib/
        cd $(pwd)/lib/
        rm -rf ./boost*
        wget https://dl.bintray.com/boostorg/release/1.73.0/source/boost_1_73_0.tar.gz
        tar xf boost_1_73_0.tar.gz
    )
fi

docker run \
    -v $(pwd)/context/:/context/ \
    -v $(pwd)/output/:/output/ \
    -v $(pwd)/lib/:/user_lib/ \
    -ti --entrypoint "/context/build.sh" \
    jonywtf/bb_rust

IP_ADDRESS=192.168.4.252
# scp -oUserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $(pwd)/output/ldd root@${IP_ADDRESS}:/sdcard/
scp -oUserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $(pwd)/output/future root@${IP_ADDRESS}:/sdcard/
scp -oUserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $(pwd)/output/future_static root@${IP_ADDRESS}:/sdcard/