#!/bin/bash

set -e

SD1D_DIR=$(pwd)

DEPS_DIR=$SD1D_DIR/dependencies
mkdir -p $DEPS_DIR
echo $DEPS_DIR

echo "Building FFTW"
cd $DEPS_DIR
mkdir -p fftw-build
wget https://www.fftw.org/fftw-3.3.10.tar.gz
tar xzf fftw-3.3.10.tar.gz
rm fftw-3.3.10.tar.gz
cd fftw-3.3.10
./configure --prefix $DEPS_DIR/fftw-build --enable-shared --enable-sse2 --enable-avx --enable-avx2 --enable-avx512 --enable-avx-128-fma
make -j 16
make install
 
echo "Building HDF5"
cd $DEPS_DIR
mkdir -p hdf5-build
wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-1.12.1/src/hdf5-1.12.1.tar.bz2
tar xjf hdf5-1.12.1.tar.bz2
rm hdf5-1.12.1.tar.bz2
cd hdf5-1.12.1
./configure --prefix $DEPS_DIR/hdf5-build --enable-build-mode=production
make -j 16
make install

echo "Building NetCDF"
cd $DEPS_DIR
mkdir -p netcdf-build
wget https://downloads.unidata.ucar.edu/netcdf-c/4.8.1/netcdf-c-4.8.1.tar.gz
tar xzf netcdf-c-4.8.1.tar.gz
rm netcdf-c-4.8.1.tar.gz
cd netcdf-c-4.8.1
CPPFLAGS="-I$DEPS_DIR/hdf5-build/include" LDFLAGS="-L$DEPS_DIR/hdf5-build/lib/" ./configure --prefix=$DEPS_DIR/netcdf-build
make -j 16
make install
 
echo "Building NetCDF-CXX4"
cd $DEPS_DIR
wget https://downloads.unidata.ucar.edu/netcdf-cxx/4.3.1/netcdf-cxx4-4.3.1.tar.gz
tar xzf netcdf-cxx4-4.3.1.tar.gz
rm netcdf-cxx4-4.3.1.tar.gz
cd netcdf-cxx4-4.3.1
CPPFLAGS="-I$DEPS_DIR/hdf5-build/include -I$DEPS_DIR/netcdf-build/include" LDFLAGS="-L$DEPS_DIR/hdf5-build/lib/ -L$DEPS_DIR/netcdf-build/lib/" ./configure --prefix=$DEPS_DIR/netcdf-build
make -j 16
make install

echo "Building PETSc"
if [ -z ${PETSC_DIR+x} ]; then
  unset PETSC_DIR
fi
if [ -z ${PETSC_ARCH+x} ]; then
  unset PETSC_ARCH
fi
cd $DEPS_DIR
mkdir petsc-build
wget https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.16.3.tar.gz
tar xzf petsc-3.16.3.tar.gz
rm petsc-3.16.3.tar.gz
cd petsc-3.16.3
./configure COPTFLAGS="-O3" CXXOPTFLAGS="-O3" FOPTFLAGS="-O3" --download-hypre --with-debugging=0 --prefix=$DEPS_DIR/petsc-build
make -j 16 PETSC_DIR=$PWD PETSC_ARCH=arch-linux-c-opt all
make -j 16 PETSC_DIR=$PWD PETSC_ARCH=arch-linux-c-opt install
make -j 16 PETSC_DIR=$PWD/../petsc-build PETSC_ARCH="" check

echo "Done building dependencies"
