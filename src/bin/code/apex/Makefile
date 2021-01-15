FC 	= gfortran
CC     = gcc
LD      = $(FC)
# LDFLAGS = #-ipo
FFLAGS 	= -O3 -fPIC #-ipo -check bounds -check pointer -check uninit


APEXSRCS	= 	checkapexsh.f90 apexsh.f90 makeapexsh.f90 apex.f magfld.f


RELEASE_DIR = ../../

ifeq ($(OS),Windows_NT)
    uname_S := Windows
else
    uname_S := $(shell uname -s)
endif

ifeq ($(uname_S),Darwin)        # Mac OS X
    apexo    = apex_macos.so
endif
ifeq ($(uname_S),Linux)
    apexo = apex_linux.so
endif

apexsh.o      : apexsh.f90  
	$(FC) -c $(FFLAGS) $<

checkapexsh.o        : checkapexsh.f90 
	$(FC) -c $(FFLAGS) $<

apex.o      : apex.f  
	$(FC) -c $(FFLAGS) $<

magfld.o      : magfld.f
	$(FC) -c $(FFLAGS) $<

makeapexsh.o      : makeapexsh.f90 apexsh.o  
	$(FC) -c $(FFLAGS) $<


apex:
	$(FC)  -shared -o $(apexo) $(FFLAGS)  $(APEXSRCS)

apexcp:
	cp -f $(apexo) $(RELEASE_DIR)$(apexo) 
	cp -f apexsh.dat $(RELEASE_DIR)

all: apex


