# (c) Tomáš Mark 2024

# Set system name and processor
set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_SYSTEM_PROCESSOR x86_64)
set(CROSS_HOST "x86_64-w64-mingw32") # This is the host system

# Define sysroot
set(CMAKE_SYSROOT /home/tomas/x-tools/x86_64-w64-mingw32/x86_64-w64-mingw32/sysroot)

# Specify cross-compilers
set(CMAKE_C_COMPILER /home/tomas/x-tools/x86_64-w64-mingw32/bin/x86_64-w64-mingw32-gcc)
set(CMAKE_CXX_COMPILER /home/tomas/x-tools/x86_64-w64-mingw32/bin/x86_64-w64-mingw32-g++)
set(CMAKE_ASM_COMPILER /home/tomas/x-tools/x86_64-w64-mingw32/bin/x86_64-w64-mingw32-as)
set(CMAKE_LINKER /home/tomas/x-tools/x86_64-w64-mingw32/bin/x86_64-w64-mingw32-ld)
set(CMAKE_AR /home/tomas/x-tools/x86_64-w64-mingw32/bin/x86_64-w64-mingw32-ar)
set(CMAKE_RANLIB /home/tomas/x-tools/x86_64-w64-mingw32/bin/x86_64-w64-mingw32-ranlib)
set(CMAKE_STRIP /home/tomas/x-tools/x86_64-w64-mingw32/bin/x86_64-w64-mingw32-strip)
set(CMAKE_LIBTOOL /home/tomas/x-tools/x86_64-w64-mingw32/bin/x86_64-w64-mingw32-libtool)

# where is the CMAKE_FIND_ROOT_PATH target environment located
set(CMAKE_FIND_ROOT_PATH ${CMAKE_SYSROOT})

# adjust the default behavior of the FIND_XXX() commands: search programs in the host environment
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)

# search headers and libraries in the target environment
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# Set the path for pkg-config
set(ENV{PKG_CONFIG_PATH} "${CMAKE_SYSROOT}/usr/lib/pkgconfig:${CMAKE_SYSROOT}/usr/share/pkgconfig")
