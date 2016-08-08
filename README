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

1. ./scripts/build_wheels.sh : builds wheels for _requirement sets_ in `reqsets?
2. ./scripts/package_wheels.sh : package each wheel to system package (deb in this example)
3. ./scripts/package_my_pkg.sh : package end-point-application