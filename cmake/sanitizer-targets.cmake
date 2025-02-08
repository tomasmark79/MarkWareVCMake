# ==============================================================================
# Sanitizers
# ==============================================================================
function(apply_sanitizers TARGET_NAME)

    message(Sanitizer target=${TARGET_NAME})

    if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")

        if(SANITIZE_ADDRESS)
            target_compile_options(${TARGET_NAME} PRIVATE -fsanitize=address
                                                          -fno-omit-frame-pointer)
            target_link_options(${TARGET_NAME} PRIVATE -fsanitize=address -static-libasan)
            set(ENV{ASAN_OPTIONS} "detect_leaks=1:strict_string_checks=1")
        endif()

        if(SANITIZE_UNDEFINED)
            target_compile_options(${TARGET_NAME} PRIVATE -fsanitize=undefined)
            target_link_options(${TARGET_NAME} PRIVATE -fsanitize=undefined)
        endif()

        if(SANITIZE_THREAD)
            if(SANITIZE_ADDRESS)
                message(FATAL_ERROR "Thread sanitizer is not compatible with Address sanitizer")
            endif()
            target_compile_options(${TARGET_NAME} -fsanitize=thread)
            target_link_options(${TARGET_NAME} -fsanitize=thread)
        endif()

        if(SANITIZE_MEMORY)
            if(SANITIZE_ADDRESS OR SANITIZE_THREAD)
                message(
                    FATAL_ERROR
                        "Memory sanitizer is not compatible with Address or Thread sanitizer")
            endif()
            target_compile_options(${TARGET_NAME} -fsanitize=memory)
            target_link_options(${TARGET_NAME} -fsanitize=memory)
        endif()

    else()
        message(WARNING "Sanitizers are only supported for GCC and Clang")
    endif()
endfunction()
