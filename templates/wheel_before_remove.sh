#!/bin/sh
reqset=$(echo <%= name %>|cut -d'-' -f1)
whldirsymlink=/tmp/wheelio/$reqset/unpacked/<%= name %>.whl.dir
realwheelname=$(basename $(readlink -f $whldirsymlink))

rm /tmp/wheelio/$reqset/$realwheelname
rm /tmp/wheelio/$reqset/$(basename $whldirsymlink|sed s@.dir@@)

