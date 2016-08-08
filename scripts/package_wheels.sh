# Generate wheel "resource debs"
unpack_script=$(readlink -f templates/wheel_unpack.sh)
pre_remove_script=$(readlink -f templates/wheel_before_remove.sh)
curdir=$(pwd)

for p in $(find . -wholename './dist/wheels/*.whl'); do
	# The wheel filename is {distribution}-{version}(-{build tag})?-{python tag}-{abi tag}-{platform tag}.whl .

	p=$(readlink -f $p)
	fname=$(basename $p)
	

	reqsetname=$(dirname $p|rev|cut -d'/' -f1|rev )
	#pytag=$(echo $fname|rev|cut -d'.' -f2-|rev |rev|cut -d'-' -f3|rev|tr '-' '_')
	
	pkgname=$reqsetname-wheel-$(echo $fname|cut -d'-' -f1)
	pkgversion=$(echo $fname|cut -d'-' -f2)
	pathtowheel=$p
	
	installdir=/tmp/wheelio/$reqsetname/unpacked/
	outdir=$(dirname $p|sed 's@wheels@debs@')
	mkdir -p $outdir

	buildroot=$curdir/buildroot/tmp-$fname/	
	mkdir -p $buildroot
	
	[ ! -d $buildroot ] && break
	cd $buildroot
	echo $buildroot $(pwd)
	

	mkdir -p $buildroot/$(basename $pathtowheel)
	cd $buildroot/$(basename $pathtowheel) && unzip $pathtowheel >/dev/null&& cd $buildroot
	


	# Symlink with simpler name also
	ln -s $(basename $pathtowheel) ./$pkgname.whl.dir
	fpm -f -s dir -t deb -n $pkgname -v $pkgversion -p $outdir \
	    -d zip \
	 	--template-scripts \
	 	--after-install $unpack_script \
	 	--before-remove $pre_remove_script \
		./$pkgname.whl.dir=$installdir \
		 $(basename $pathtowheel)=$installdir
	

	cd $curdir
	rm -rf $buildroot

done
