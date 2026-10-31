# SPDX-License-Identifier: GPL-3.0-only

if(NOT DEFINED INVADER_BUILD)
    set(INVADER_BUILD true CACHE BOOL "Build invader-build (builds cache files)")
endif()

if(${INVADER_BUILD})
    add_executable(invader-build
        src/build/build.cpp
    )

    target_link_libraries(invader-build invader ${INVADER_CRT_NOGLOB})

    set(TARGETS_LIST ${TARGETS_LIST} invader-build)

    if(WIN32)
        target_sources(invader-build PRIVATE src/build/build.rc)
    endif()

    # Compiling a tag walks the scenario's references recursively, and large Shadowrun tags overflow the
    # default 1 MiB stack (0xC00000FD) before a map is ever written. MSVC honours /STACK; MinGW needs the
    # linker flag instead.
    if(MSVC)
        target_link_options(invader-build PRIVATE /STACK:16777216)
    elseif(MINGW)
        target_link_options(invader-build PRIVATE -Wl,--stack,16777216)
    endif()
endif()
