FC 	= gfortran
CC     = gcc
LD      = $(FC)
# LDFLAGS = #-ipo
FFLAGS 	= -O3 -fPIC #-ipo -check bounds -check pointer -check uninit


vdm             =   vdrift_model.for

RELEASE_DIR = ../

ifeq ($(OS),Windows_NT)
    uname_S := Windows
else
    uname_S := $(shell uname -s)
endif

ifeq ($(uname_S),Darwin)        # Mac OS X
    vdmo     = vdrift_model_macos.so
endif
ifeq ($(uname_S),Linux)
    vdmo     = vdrift_model_linux.so

endif


# vdm:
# 	$(FC)  -shared -o $(vdmo)  $(FFLAGS)  $(vdm)

all_cp:
	chapmancp
	hwmcp 
	msisecp 
	spacp 
	apexcp
all:
	cd apex; make all
	cd chapman; make all
	cd hwm; make all
	cd nrlmsise; make all
	cd spa; make all
# .PHONY: all

clean:
	rm -f */*.o */*.mod
