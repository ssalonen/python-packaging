for p in $(find -name '*example*.whl'); do
	# The wheel filename is {distribution}-{version}(-{build tag})?-{python tag}-{abi tag}-{platform tag}.whl .
	fname=$(basename $p)

	reqsetname=$(dirname $p|rev|cut -d'/' -f1|rev )
	pkgname=$reqsetname-$(echo $fname|cut -d'-' -f1)
	pkgversion=$(echo $fname|cut -d'-' -f2)
	pkgversion=$(echo $fname|cut -d'-' -f2)
	wheelpkgname=$reqsetname-${pytag}-wheel-$(echo $fname|cut -d'-' -f1)
	outdir=$(dirname $p|sed 's@wheels@rpms_endpoint@')


	virtualenvdep="$reqsetname-wheel-virtualenv"
	

	wheelpkgname=$reqsetname-wheel-$(echo $fname|cut -d'-' -f1)

	mkdir -p $outdir
	# TODO: 
	# 1. determine python dependencies of the package. Once that is done, generate list of dependencies of all the packages required, and mark them as such with -d 
	# 2. Also the after install script should could be implemented in terms of pip requirements list
	# FIXME: correct python version
	fpm -f -s dir -t rpm -n $pkgname -v $pkgversion -d unzip -d python \
		-d $virtualenvdep \
		-d $wheelpkgname \
		-d $reqsetname-wheel-numpy \
		-p $outdir --template-scripts --after-install templates/after_install.sh ./README=/tmp/README


done
