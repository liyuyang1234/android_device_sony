#!/bin/sh
# Copyright (C) 2011-2013 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

VENDOR=sony
DEVICE=nozomi

BASE=../../../vendor/$VENDOR/$DEVICE/proprietary

while getopts ":nh" options
do
  case $options in
    n ) NC=1 ;;
    h ) echo "Usage: `basename $0` [OPTIONS] "
        echo "  -n  No clenup"
        echo "  -h  Show this help"
        exit ;;
    * ) ;;
  esac
done

if [ "x$NC" != "x1" ];
then
    rm -rf $BASE/*
fi

for FILE in `cat proprietary-files.txt | grep -v ^# | grep -v ^$`; do
    # Split the file from the destination (format is "file[:destination]")
    OLDIFS=$IFS IFS=":" PARSING_ARRAY=($FILE) IFS=$OLDIFS
    FILE=${PARSING_ARRAY[0]}
    DIR=`dirname $FILE`
    if [ ! -d $BASE/$DIR ]; then
        mkdir -p $BASE/$DIR
    fi
    adb pull /system/$FILE $BASE/$FILE
done

./setup-makefiles.sh
