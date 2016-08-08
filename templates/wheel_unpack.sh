#!/bin/sh
reqset=$(echo <%= name %>|cut -d'-' -f1)
# Escape dashes with underscores to get wheel name from package name
escapedname=$(echo <%= name %>|cut -d'-' -f-2)-$(echo <%= name %>|cut -d'-' -f3-|tr '-' '_')
whldirsymlink=/tmp/wheelio/$reqset/unpacked/${escapedname}.whl.dir
realwheelname=$(basename $(readlink -f $whldirsymlink))

cd $whldirsymlink
#echo "Wheeling dir $(pwd) to /tmp/wheelio/$reqset/$realwheelname"
zip -r /tmp/wheelio/$reqset/$realwheelname . > /dev/null
#echo "Symlinking /tmp/wheelio/$reqset/$realwheelname /tmp/wheelio/$reqset/<%= name %>.whl"
ln -s /tmp/wheelio/$reqset/$realwheelname /tmp/wheelio/$reqset/<%= name %>.whl > /dev/null

