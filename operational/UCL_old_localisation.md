# UCL Personalisation

This document describes the steps needed to set up and operationalise this script on the UCL servers. 

Firstly the UCL system has some curated directories to contain a standard set of files. Several of these directories consist solely of symbolic linsk to the ESGF downloaded data.

## pre-installation
One would expect that conda would be able to provide the necessary compilers and libraries to get this to work well. Ideally this should just require `conda install netcdf-fortran`, but disappointingly this seems a long way off working properly.

Instead I have decided to compile specific (and up-to-date) versions of netcdf-c and netcdf-fortran to try to get the best support in the package. This requires a bare-bones conda environment.yml with packages required to install them. 

The process to be followed is...
- Download netcdf-c from https://github.com/Unidata/netcdf-c
- unzip and move into that directory
- `autoreconf -ivf -I /home/p2f-v/.conda/envs/paleocaladjust/include/`
- `./configure --prefix=/home/p2f-v/DATA/PaleoCalAdjust/netcdf/`
- make check install
- Download netcdf-fortran from https://github.com/Unidata/netcdf-fortran
- unzip and move into that directory
- `autoreconf -ivf -I /home/p2f-v/.conda/envs/paleocaladjust/include/`
- `NCDIR=/home/p2f-v/DATA/PaleoCalAdjust/netcdf`
- `export LD_LIBRARY_PATH=${NCDIR}/lib:${LD_LIBRARY_PATH}`
- `CPPFLAGS=-I${NCDIR}/include LDFLAGS=-L${NCDIR}/lib ./configure --prefix=${NCDIR}`
- make check install

## cal_adj_curated
This is a just a copy of the cal_adjust_PMIP script. It has the location of the additional cal-adj string altered, so that it can be treated like a separate experiment. It also has the (hardwired) path of the cad_adj-info.csv file changed to be "./" - as it will only be launched from the operational directory  


## operational
This is a special directory for the deployment of the software. It has:
- a bash script that automatically scours the curated archive and adjusts any newly added files
- a makefile with appropriate paths, so for the libraries created above
- The actual executable is then compiled with `make`
