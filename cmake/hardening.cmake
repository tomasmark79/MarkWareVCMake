include(CheckCXXCompilerFlag)

function(apply_hardening target)
    if(NOT ENABLE_HARDENING)
        return()
    endif()

    message(STATUS "Enabling hardening for target ${target}")
    
    if(MSVC)
        set(HARDENING_FLAGS
            /GS        # Buffer security check
            /DYNAMICBASE # Random base address
            /NXCOMPAT  # Data execution prevention
            /CETCOMPAT # Control flow protection
            /HIGHENTROPYVA # High entropy ASLR
        )
    else()
        set(HARDENING_FLAGS
            -fstack-protector-strong # Stack smashing protection
            -fPIE # Position independent executable
            -D_FORTIFY_SOURCE=2 # Additional buffer overflow checks
            -fstack-clash-protection # Stack clash protection
            -fcf-protection # Control flow protection
            -fno-common # Disallow common symbols
        )

        if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
            list(APPEND HARDENING_FLAGS
                -fsanitize=safe-stack # Safe stack protection
                -fsanitize=cfi # Control flow integrity
            )
        endif()
    endif()

    target_compile_options(${target} PRIVATE ${HARDENING_FLAGS})
    
    if(NOT MSVC)
        target_link_options(${target} PRIVATE 
            -Wl,-z,relro # Relocation read-only
            -Wl,-z,now # No lazy binding
            -Wl,-z,noexecstack # No executable stack
            -Wl,-z,separate-code # Separate code and data
        )
    endif()
endfunction()