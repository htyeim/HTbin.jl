FC 	= gfortran
CC     = gcc
LD      = $(FC)
# LDFLAGS = #-ipo
FFLAGS 	= -O3 -fPIC #-ipo -check bounds -check pointer -check uninit


CHAPMANSRCS     =   chapman.for


RELEASE_DIR = ../../

ifeq ($(OS),Windows_NT)
    uname_S := Windows
else
    uname_S := $(shell uname -s)
endif

ifeq ($(uname_S),Darwin)        # Mac OS X
	chapmano = chapman_macos.so
endif
ifeq ($(uname_S),Linux)
	chapmano = chapman_linux.so
endif

chapman:
	$(FC)  -shared -o $(chapmano)  $(FFLAGS)  $(CHAPMANSRCS)
chapmancp:
	cp -f $(chapmano) $(RELEASE_DIR)$(chapmano)
	
all:chapman