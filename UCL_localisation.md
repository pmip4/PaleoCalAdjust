# UCL Personalisation

This document describes the steps needed to set up and operationalise this script on the UCL servers. With v1.0 of the software this was a much more awkward process (you can see the old localisation step in operational).

## Setting up conda
I have a conda environment specifically to compile and run this piece of software. It only needs `netcdf-fortran` and the LD_LIBRARY_PATH to be sorted. 

I called my environment "paleocaladjust" and modified the makefile in 'operational/' to reflect the resultant paths. 

`conda env create -c conda-forge -n paleocaladjust netcdf-fortran`
`conda env config vars set -p ~/.conda/envs/paleocaladjust LD_LIBRARY_PATH=~/.conda/envs/paleocaladjust/lib/:${LD_LIBRARY_PATH}`

## operational
This is a special directory for the deployment of the software. It has:
- a bash script that automatically scours the curated archive and adjusts any newly added files
- a makefile with appropriate paths, i.e. for the conda libraries created above
- The actual executable is then compiled with `make`
