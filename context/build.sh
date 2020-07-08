#!/bin/bash
set -e

cd /context
# cp /root/x-tools/arm-unknown-linux-uclibcgnueabi/arm-unknown-linux-uclibcgnueabi/sysroot/usr/bin/ldd /output

# export CXX=/root/x-tools/arm-unknown-linux-uclibcgnueabi/bin/arm-unknown-linux-uclibcgnueabi-g++
# export GCC=/root/x-tools/arm-unknown-linux-uclibcgnueabi/bin/arm-unknown-linux-uclibcgnueabi-gcc
# export CC=/root/x-tools/arm-unknown-linux-uclibcgnueabi/bin/arm-unknown-linux-uclibcgnueabi-cc
# export AR=/root/x-tools/arm-unknown-linux-uclibcgnueabi/bin/arm-unknown-linux-uclibcgnueabi-ar
# export RANLIB=/root/x-tools/arm-unknown-linux-uclibcgnueabi/bin/arm-unknown-linux-uclibcgnueabi-ranlib

export CXX=/arm-hisiv510-linux/bin/arm-hisiv510-linux-uclibcgnueabi-c++
export GCC=/arm-hisiv510-linux/bin/arm-hisiv510-linux-uclibcgnueabi-gcc-6.2.1
export CC=${GCC}
export AR=/arm-hisiv510-linux/arm-hisiv510-linux-uclibcgnueabi/bin/ar
export RANLIB=/arm-hisiv510-linux/arm-hisiv510-linux-uclibcgnueabi/bin/ranlib

${CXX} -Wall -Os -s -std=c++11 -fexceptions -o future future.cpp \
    -I/user_lib/boost_1_73_0/ \
    -Wl,-Bdynamic -L/hisdk/lib/ -lmpi -lVoiceEngine -ldnvqe -lupvqe  -Wl,--warn-unresolved-symbols
readelf -d future
# /root/x-tools/arm-unknown-linux-uclibcgnueabi/arm-unknown-linux-uclibcgnueabi/sysroot/usr/bin/ldd future
cp future /output

${CXX} -Wall -Os -s -std=c++11 -o future_static future.cpp -static \
    -Wl,-Bdynamic -L/hisdk/lib/ -lmpi -lVoiceEngine -ldnvqe -lupvqe  -Wl,--warn-unresolved-symbols
readelf -d future_static
cp future_static /output
