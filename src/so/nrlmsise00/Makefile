FC 	= gfortran
CC     = gcc
LD      = $(FC)
# LDFLAGS = #-ipo
FFLAGS 	= -O3 -fPIC #-ipo -check bounds -check pointer -check uninit


NRLMISISE00SRCS_i	= 	nrlmsise00_modified.f

RELEASE_DIR = ../../

ifeq ($(OS),Windows_NT)
    uname_S := Windows
else
    uname_S := $(shell uname -s)
endif

ifeq ($(uname_S),Darwin)        # Mac OS X
    msiseo   = nrlmsise00_macos.so
	NRLMISISE00SRCS = $(NRLMISISE00SRCS_i)
endif
ifeq ($(uname_S),Linux)
    msiseo   = nrlmsise00_linux.so
	NRLMISISE00SRCS = -fPIC $(NRLMISISE00SRCS_i)
endif


msise:
	$(FC)  -shared -o $(msiseo) -fno-range-check -fno-automatic -ffixed-line-length-none $(NRLMISISE00SRCS)
msisecp:
	cp -f $(msiseo) $(RELEASE_DIR)$(msiseo) 

all: msise
cp: msisecp