#! /bin/sh

# This file is a part of MRNIU/nzh_factorio_mod
# (https://github.com/MRNIU/nzh_factorio_mod).
#
# releash.sh for MRNIU/nzh_factorio_mod.

set -x
set -e

mkdir nzh_factorio_mod
cp -r ./.README.assets ./nzh_factorio_mod
cp -r ./bottleneck ./nzh_factorio_mod
cp -r ./flib ./nzh_factorio_mod
cp -r ./graphics ./nzh_factorio_mod
cp -r ./handcraft ./nzh_factorio_mod
cp -r ./locale ./nzh_factorio_mod
cp -r ./longreach ./nzh_factorio_mod
cp -r ./nightvision ./nzh_factorio_mod
cp -r ./prototypes ./nzh_factorio_mod
cp -r ./pumpanywhere ./nzh_factorio_mod
cp -r ./startup ./nzh_factorio_mod
cp -r ./time ./nzh_factorio_mod
cp -r ./tinyequipment ./nzh_factorio_mod
cp -r ./changelog.txt ./nzh_factorio_mod
cp -r ./*.lua ./nzh_factorio_mod
cp -r ./info.json ./nzh_factorio_mod
cp -r ./LICENSE ./nzh_factorio_mod
cp -r ./README.md ./nzh_factorio_mod
cp -r ./thumbnail.png ./nzh_factorio_mod

zip -mrv nzh_factorio_mod.zip nzh_factorio_mod

rm -rf nzh_factorio_mod
