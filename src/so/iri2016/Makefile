# f77flags = -std=legacy -w -O2 -fbacktrace -fno-automatic -fPIC

# fortran_files = cira.for igrf.for iridreg_modified.for irifun.for irisub.for iritec.for iriflip_modified.for cosd_sind.for

	# gfortran $(f77flags) -o test_gfortran.x simple_iri_driver.for $(fortran_files)
FC 	= gfortran
CC     = gcc
LD      = $(FC)
# LDFLAGS = #-ipo
FFLAGS 	= -O3 -fPIC #-ipo -check bounds -check pointer -check uninit


# APEXSRCS	= 	checkapexsh.f90 apexsh.f90 makeapexsh.f90 apex.f magfld.f
IRISRCS 	= cira.for igrf.for iridreg.for irifun.for irisub.for iritec.for iriflip.for 


RELEASE_DIR = ../../

ifeq ($(OS),Windows_NT)
    uname_S := Windows
else
    uname_S := $(shell uname -s)
endif

ifeq ($(uname_S),Darwin)        # Mac OS X
    irio    = iri2016_macos.so
endif
ifeq ($(uname_S),Linux)
    irio = iri2016_linux.so
endif



iri2016:
	$(FC)  -shared -o $(irio) $(FFLAGS)  $(IRISRCS)

iri2016cp:
	cp -f $(apexo) $(RELEASE_DIR)$(apexo) 
	cp -f apexsh.dat $(RELEASE_DIR)

all: iri2016


