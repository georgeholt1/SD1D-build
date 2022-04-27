#!/bin/bash

git clone https://github.com/boutproject/SD1D.git
DEPS_DIR=$(pwd)/dependencies
cd SD1D
cmake . -B build -DCMAKE_BUILD_TYPE=Release -DCHECK=0 -DBOUT_DOWNLOAD_SUNDIALS=ON -DBOUT_USE_PETSC=ON -DPETSC_DIR=$DEPS_DIR/petsc-build -DPETSC_ARCH="" -DBOUT_USE_HDF5=OFF -DNC_CONFIG=$DEPS_DIR/netcdf-build/bin/nc-config -DNCXX4_CONFIG=$DEPS_DIR/netcdf-build/bin/ncxx4-config -DFFTW_ROOT=$DEPS_DIR/fftw-build -DBOUT_IGNORE_CONDA_ENV=ON
cmake --build build -j 16
