FC 	= gfortran
CC     = gcc
LD      = $(FC)
# LDFLAGS = #-ipo
FFLAGS 	= -O3 -fPIC #-ipo -check bounds -check pointer -check uninit



SPASRCS_i   = spa.c spa_tester.c


RELEASE_DIR = ../../

ifeq ($(OS),Windows_NT)
    uname_S := Windows
else
    uname_S := $(shell uname -s)
endif

ifeq ($(uname_S),Darwin)        # Mac OS X
    SPASRCS  = $(SPASRCS_i)
    spao     = spa_macos.so
	
	
endif
ifeq ($(uname_S),Linux)
    SPASRCS	 =  spa.h $(SPASRCS_i)
    spao     = spa_linux.so   
endif


spa:
	$(CC)  -shared -o $(spao) $(FFLAGS)  $(SPASRCS)
spacp:
	cp -f $(spao) $(RELEASE_DIR)$(spao) 

all: spa
cp: spacp