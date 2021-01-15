
# APEX:
x86_64-w64-mingw32-gfortran.exe -shared -o apex_win.so -O3 -fPIC checkapexsh.f90 apexsh.f90 makeapexsh.f90 apex.f magfld.f

# SPA:
x86_64-w64-mingw32-gcc-8.1.0.exe -shared -o spa_win.so -O3 -fPIC spa.c spa_tester.c

# HWM:
x86_64-w64-mingw32-gfortran.exe -shared -o hwm14_win.so -O3 -fPIC hwm14.f90

# NRLMISISE:
x86_64-w64-mingw32-gfortran.exe -shared -o msise00_win.so -O3 -fPIC  -fno-range-check -fno-automatic -ffixed-line-length-none  nrlmsise00_modified.f

# CHAPMAN:
x86_64-w64-mingw32-gfortran.exe -shared -o chapman_win.so -O3 -fPIC chapman.for
