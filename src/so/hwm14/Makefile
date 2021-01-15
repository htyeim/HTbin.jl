FC 	= gfortran
CC     = gcc
LD      = $(FC)
# LDFLAGS = #-ipo
FFLAGS 	= -O3 -fPIC #-ipo -check bounds -check pointer -check uninit

HWM14SRCS		= 	hwm14.f90


RELEASE_DIR = ../../

ifeq ($(OS),Windows_NT)
    uname_S := Windows
else
    uname_S := $(shell uname -s)
endif

ifeq ($(uname_S),Darwin)        # Mac OS X
    hwm14o   = hwm14_macos.so
endif
ifeq ($(uname_S),Linux)
	hwm14o   = hwm14_linux.so
endif



hwm:
	$(FC)  -shared -o $(hwm14o) $(FFLAGS)  $(HWM14SRCS)
hwmcp:
	cp -f $(hwm14o) $(RELEASE_DIR)$(hwm14o) 
	cp -f dwm07b104i.dat $(RELEASE_DIR)
	cp -f gd2qd.dat $(RELEASE_DIR)
	cp -f hwm123114.bin $(RELEASE_DIR)

all: hwm
cp: hwmcp