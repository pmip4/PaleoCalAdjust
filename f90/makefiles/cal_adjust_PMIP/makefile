# cal_adjust_PMIP

# (relative) paths to source files -- needs localization
prog = ../../main_programs/
mod = ../../modules/

# netCDF and OpenMP libraries -- needs localization
NCINC = /opt/anaconda/include
NCLIB = /opt/anaconda/lib
LIBS = -lnetcdff -lnetcdf -lgomp 

# compiler and flags
FC = gfortran
FFLAGS = -O3 -Wall -ffree-line-length-160

# target, object and .mod files
target = cal_adjust_PMIP
objects = pseudo_daily_interp_subs.o GISS_orbpar_subs.o spline.o mp_interp_epstein_subs.o mp_interp_harzallah_subs.o\
    GISS_srevents_subs.o month_length_subs.o cmip_netcdf_subs.o cal_adjust_PMIP.o
modules = pseudo_daily_interp_subs.mod GISS_orbpar_subs.mod spline.mod mp_interp_epstein_subs.mod mp_interp_harzallah_subs.mod\
    GISS_srevents_subs.mod month_length_subs.mod cmip_netcdf_subs.mod

$(target): $(objects) 
	$(FC) $(FFLAGS) -L$(NCLIB) -o $(target) $(objects) $(LIBS)

pseudo_daily_interp_subs.o: $(mod)pseudo_daily_interp_subs.f90
	$(FC) $(FFLAGS) -c $(mod)pseudo_daily_interp_subs.f90

GISS_orbpar_subs.o: $(mod)GISS_orbpar_subs.f90
	$(FC) $(FFLAGS) -c $(mod)GISS_orbpar_subs.f90

GISS_srevents_subs.o: $(mod)GISS_srevents_subs.f90
	$(FC) $(FFLAGS) -c $(mod)GISS_srevents_subs.f90

month_length_subs.o: $(mod)month_length_subs.f90
	$(FC) $(FFLAGS) -c $(mod)month_length_subs.f90

CMIP_netCDF_subs.o: $(mod)CMIP_netCDF_subs.f90 
	$(FC) $(FFLAGS) -I$(NCINC) -c $(mod)CMIP_netCDF_subs.f90 

spline.o: $(mod)spline.f90
	$(FC) $(FFLAGS) -I$(NCINC) -c $(mod)spline.f90

mp_interp_epstein_subs.o: $(mod)mp_interp_epstein_subs.f90 
	$(FC) $(FFLAGS) -I$(NCINC) -c $(mod)mp_interp_epstein_subs.f90 

mp_interp_harzallah_subs.o: $(mod)mp_interp_harzallah_subs.f90 
	$(FC) $(FFLAGS) -I$(NCINC) -c $(mod)mp_interp_harzallah_subs.f90 

cal_adjust_PMIP.o: $(prog)cal_adjust_PMIP.f90
	$(FC) $(FFLAGS) -fopenmp -c $(prog)cal_adjust_PMIP.f90

clean: 
	rm -f $(objects)
	rm -f $(modules)

clobber: clean
	rm -f $(target)
