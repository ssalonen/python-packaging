#!/bin/sh
reqset=$(echo <%= name %>|cut -d'-' -f1)
venvdir=/opt/<%= name %>/venv
pip=$venvdir/bin/pip




# bootstrap virtualenv
bootstrap_tmp_dir=/tmp/virtualenv-for-<%= name %>-$RANDOM
echo creating bootstrap dir $bootstrap_tmp_dir
mkdir -p $bootstrap_tmp_dir
cd $bootstrap_tmp_dir
cp /tmp/wheelio/$reqset/$reqset-wheel-virtualenv.whl $bootstrap_tmp_dir/virtualenv.whl
unzip virtualenv.whl
python $bootstrap_tmp_dir/virtualenv.py $venvdir


# install package using pip install --wheel-dir. Note that with wheels no dependencies are resolved. Thus
# all transitive dependencies need to be mentioned here. See package_my_pkg.sh for more details
$pip install --no-index -U --no-cache-dir -f /tmp/wheelio/$reqset/ an-example-pypi-project
$pip install --no-index -U --no-cache-dir -f /tmp/wheelio/$reqset/ numpy

rm -rf $bootstrap_tmp_dir

echo "HURRAY FOR <%= name %> version <%= version %>"