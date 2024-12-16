# ---- Add OpenSSL ----
if(ENABLE_OPENSSL)
    CPMAddPackage(
        NAME mwopenssl
        URL https://github.com/openssl/openssl/releases/download/openssl-3.4.0/openssl-3.4.0.tar.gz
        DOWNLOAD_ONLY YES
    )
endif()

if(mwopenssl_ADDED)
    set(OPENSSL_LIB_DIR
        ${mwopenssl_SOURCE_DIR}/mwopenssl-install-${CMAKE_SYSTEM_PROCESSOR}-${CMAKE_BUILD_TYPE}
    )
    message(STATUS "OPENSSL_LIB_DIR: ${OPENSSL_LIB_DIR}")
    
    set(OPENSSL_INCLUDE_DIR ${OPENSSL_LIB_DIR}/include)

    set(OPENSSL_CRYPTO_LIBRARY ${OPENSSL_LIB_DIR}/lib/libcrypto.a)
    set(OPENSSL_SSL_LIBRARY ${OPENSSL_LIB_DIR}/lib/libssl.a)
    set(OPENSSL_APPLINK_LIBRARY ${OPENSSL_LIB_DIR}/lib/applink.c)

    message(STATUS "mwopenssl_SOURCE_DIR: ${mwopenssl_SOURCE_DIR}")
    message(STATUS "OPENSSL_INCLUDE_DIR: ${OPENSSL_INCLUDE_DIR}")
    message(STATUS "OPENSSL_LIB_DIR: ${OPENSSL_LIB_DIR}")
    message(STATUS "OPENSSL_CRYPTO_LIBRARY: ${OPENSSL_CRYPTO_LIBRARY}")
    message(STATUS "OPENSSL_SSL_LIBRARY: ${OPENSSL_SSL_LIBRARY}")
    message(STATUS "OPENSSL_APPLINK_LIBRARY: ${OPENSSL_APPLINK_LIBRARY}")

    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        set(OPENSSL_BUILD_TYPE "--debug")
    else()
        set(OPENSSL_BUILD_TYPE "--release")
    endif()

    if(CMAKE_CROSSCOMPILING)
        if(NOT EXISTS ${OPENSSL_CRYPTO_LIBRARY} OR NOT EXISTS ${OPENSSL_SSL_LIBRARY})
            add_custom_command(
                OUTPUT ${OPENSSL_CRYPTO_LIBRARY} ${OPENSSL_SSL_LIBRARY}
                WORKING_DIRECTORY ${mwopenssl_SOURCE_DIR}
                COMMAND
                ./Configure linux-aarch64 ${OPENSSL_BUILD_TYPE} --libdir=${OPENSSL_LIB_DIR}/lib
                no-docs enable-pie --prefix=${OPENSSL_LIB_DIR} --openssldir=${CMAKE_SYSROOT}
                CC=${CMAKE_C_COMPILER} CXX=${CMAKE_CXX_COMPILER} CPP=${CMAKE_C_COMPILER}\ -E
                CXXCPP=${CMAKE_CXX_COMPILER}\ -E
                COMMAND ${CMAKE_MAKE_PROGRAM} clean
                COMMAND ${CMAKE_MAKE_PROGRAM} -j$(nproc)
                COMMAND ${CMAKE_MAKE_PROGRAM} install -j$(nproc)
                COMMENT "Cross-building openssl"
            )
        else()
            message(STATUS "OpenSSL libraries already exist, skipping build step")
        endif()
    else()
        if(NOT EXISTS ${OPENSSL_CRYPTO_LIBRARY} OR NOT EXISTS ${OPENSSL_SSL_LIBRARY})
            add_custom_command(
                OUTPUT ${OPENSSL_CRYPTO_LIBRARY} ${OPENSSL_SSL_LIBRARY}
                WORKING_DIRECTORY ${mwopenssl_SOURCE_DIR}
                COMMAND
                ./Configure linux-x86_64 ${OPENSSL_BUILD_TYPE} --libdir=${OPENSSL_LIB_DIR}/lib
                no-docs enable-pie --prefix=${OPENSSL_LIB_DIR} --openssldir=${OPENSSL_LIB_DIR}
                COMMAND ${CMAKE_MAKE_PROGRAM} clean
                COMMAND ${CMAKE_MAKE_PROGRAM} -j$(nproc)
                COMMAND ${CMAKE_MAKE_PROGRAM} install -j$(nproc)
                COMMENT "Native-building openssl"
            )
        else()
            message(STATUS "OpenSSL libraries already exist, skipping build step :-)")
        endif()
    endif()

    add_custom_target(build-openssl DEPENDS ${OPENSSL_CRYPTO_LIBRARY} ${OPENSSL_SSL_LIBRARY})
    add_dependencies(${PROJECT_LIBRARY_NAME} build-openssl)
    target_include_directories(${PROJECT_LIBRARY_NAME} PUBLIC ${OPENSSL_INCLUDE_DIR})
endif()