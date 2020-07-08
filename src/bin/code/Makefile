FC 	= gfortran
CC     = gcc
LD      = $(FC)
# LDFLAGS = #-ipo
FFLAGS 	= -O3 -fPIC #-ipo -check bounds -check pointer -check uninit

APEXSRCS	= 	checkapexsh.f90 apexsh.f90 makeapexsh.f90 apex.f magfld.f
OBJS	    = checkapexsh.o apexsh.o makeapexsh.o apex.o magfld.o

SPASRCS_i   = spa.c spa_tester.c

NRLMISISE00SRCS_i	= 	nrlmsise00_modified.f
HWM14SRCS		= 	hwm14.f90
CHAPMANSRCS     =   chapman.for
# vdm             =   vdrift_model.for

RELEASE_DIR = ../

ifeq ($(OS),Windows_NT)
    uname_S := Windows
else
    uname_S := $(shell uname -s)
endif

ifeq ($(uname_S),Darwin)        # Mac OS X
    apexo    = apex_macos.so

    SPASRCS  = $(SPASRCS_i)
    spao     = spa_macos.so
	
    msiseo   = msise00_macos.so
	NRLMISISE00SRCS = $(NRLMISISE00SRCS_i)
    hwm14o   = hwm14_macos.so
    chapmano = chapman_macos.so
    vdmo     = vdrift_model_macos.so
endif
ifeq ($(uname_S),Linux)
    apexo = apex_linux.so

    SPASRCS	 =  spa.h $(SPASRCS_i)
    spao     = spa_linux.so
    
    msiseo   = msise00_linux.so
	NRLMISISE00SRCS = -fPIC $(NRLMISISE00SRCS_i)
    hwm14o   = hwm14_linux.so
    chapmano = chapman_linux.so
    vdmo     = vdrift_model_linux.so

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

spa:
	$(CC)  -shared -o $(spao) $(FFLAGS)  $(SPASRCS)
spacp:
	cp -f $(spao) $(RELEASE_DIR)$(spao) 

msise:
	$(FC)  -shared -o $(msiseo) -fno-range-check -fno-automatic -ffixed-line-length-none $(NRLMISISE00SRCS)
msisecp:
	cp -f $(msiseo) $(RELEASE_DIR)$(msiseo) 

hwm:
	$(FC)  -shared -o $(hwm14o) $(FFLAGS)  $(HWM14SRCS)
hwmcp:
	cp -f $(hwm14o) $(RELEASE_DIR)$(hwm14o) 
	cp -f dwm07b104i.dat $(RELEASE_DIR)
	cp -f gd2qd.dat $(RELEASE_DIR)
	cp -f hwm123114.bin $(RELEASE_DIR)

chapman:
	$(FC)  -shared -o $(chapmano)  $(FFLAGS)  $(CHAPMANSRCS)
chapmancp:
	cp -f $(chapmano) $(RELEASE_DIR)$(chapmano) 

# vdm:
# 	$(FC)  -shared -o $(vdmo)  $(FFLAGS)  $(vdm)
all_cp: chapmancp  hwmcp msisecp spacp apexcp
all: apex spa msise hwm chapman all_cp
# .PHONY: all

clean:
	rm -f *.o *.mod
