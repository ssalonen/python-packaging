## Motivation

Experimentation of packaging python software with the following requirements

- support for native system level packaging
- delta-rpm support in case of rpms
- separated virtualenvs for each application
- fast install
- support for numpy etc. c level api dependencies

## Solution

In this solution we have a pin list representing "well known configuration". The python packages in the pin list are pre-compiled into wheels. Note that one can have many parallel well known configurations, e.g. for different numpy API's or python 2/3.

The wheels are packaged to dummy system packages, which just unzip the wheels to target system. The wheels are unzipped inside the package in order to have good delta-compression (see delta rpm requirements). On post-install the `whl` file is reconstructed from the unzipped directory. TODO: does delta rpm go traverse inside wheel zips automatically? In this exercise, there are dependencies declared between the dummy system packages. Even the python library corresponding to the endpoint application gets and dummy wheel. The packages are prefixed with `PINLIST-wheel-` to separate them from real working packages.

Finally, the end point application (`an_example_pypi_project`) depends on the dummy system packages. In addition to the runtime requirements, we depend on virtualenv which is used for bootstrapping the environment.

## Usage

1. ./scripts/build_wheels.sh : builds wheels for _requirement sets_ in `reqsets`?

Using docker: `rm -rf dist buildroot; docker run -it --rm -v $(pwd):$(pwd) -w $(pwd) centos:7 bash -c "yum install -y python-setuptools wget; wget https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip.py ; python2.7 /tmp/get-pip.py; scripts/build_wheels.sh"`

2. ./scripts/package_wheels.sh : package each wheel to system package (rpm in this example)

Using temporary docker container (TODO: create docker image for this purpose): 
````
docker run -it --rm -v $(pwd):$(pwd) -w $(pwd) centos:7 bash -c "\
	yum install -y unzip rpm-build python-setuptools wget gcc make centos-release-scl \
	&& yum install -y  ruby200-ruby-devel \
	&& wget https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip.py && python2.7 /tmp/get-pip.py \
	&& scl enable ruby200 \"gem install fpm\" && \
	scl enable ruby200 \"sh -c 'PATH=/opt/rh/ruby200/root/usr/local/bin/:$PATH scripts/package_wheels.sh'\" "
````


3. ./scripts/package_my_pkg.sh : package end-point-application

Using docker (TODO: create docker image for this purpose): 
````
docker run -it --rm -v $(pwd):$(pwd) -w $(pwd) centos:7 bash -c "\
	yum install -y unzip rpm-build python-setuptools wget gcc make centos-release-scl \
	&& yum install -y  ruby200-ruby-devel ruby-rubygems \
	&& wget https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip.py && python2.7 /tmp/get-pip.py \
	&& scl enable ruby200 \"gem install fpm\" && \
	scl enable ruby200 \"sh -c 'PATH=/opt/rh/ruby200/root/usr/local/bin/:$PATH scripts/package_my_pkg.sh'\" "
````

4. Test:

````
docker run -it --rm -v $(pwd):$(pwd) -w $(pwd) centos:7 bash -c "\
	yum install -y dist/debs/reqsset3/{reqsset3-wheel-an_example_pypi_project-0.0.4-1.x86_64.rpm,reqsset3-wheel-numpy-1.11.1-1.x86_64.rpm,reqsset3-wheel-virtualenv-15.0.3-1.x86_64.rpm} \
	dist/debs_app/reqsset3/reqsset3-an_example_pypi_project-0.0.4-1.x86_64.rpm \
	&& /opt/reqsset3-an_example_pypi_project/venv/bin/python -c \"import numpy as np; print 'from numpy:', np.sqrt(4.5); import an_example_pypi_project; print an_example_pypi_project\" "
````