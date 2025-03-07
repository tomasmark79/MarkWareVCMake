# MIT License
# Copyright (c) 2024-2025 Tomáš Mark

function(copy_assets target asset_sources destination)
    add_custom_command(
        TARGET ${target}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E make_directory "${destination}"
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${asset_sources} "${destination}")
endfunction()

function(apply_assets_processing)
    set(ASSET_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../assets/")
    set(ASSET_INSTALL_DIR_POSIX "share/${STANDALONE_NAME}/assets")
    set(ASSET_INSTALL_DIR_WIN32 "assets")
    set(ASSET_BUILD_DIR_POSIX "$<TARGET_FILE_DIR:${STANDALONE_NAME}>/../${ASSET_INSTALL_DIR_POSIX}")
    set(ASSET_BUILD_DIR_WIN32 "$<TARGET_FILE_DIR:${STANDALONE_NAME}>/${ASSET_INSTALL_DIR_WIN32}")

    if(UNIX AND NOT APPLE)
        set(ASSET_BUILD_DIR ${ASSET_BUILD_DIR_POSIX})
        set(ASSET_INSTALL_DIR ${ASSET_INSTALL_DIR_POSIX})
    elseif(APPLE)
        set(ASSET_BUILD_DIR ${ASSET_BUILD_DIR_POSIX})
        set(ASSET_INSTALL_DIR ${ASSET_INSTALL_DIR_POSIX})
    elseif(WIN32)
        set(ASSET_BUILD_DIR ${ASSET_BUILD_DIR_WIN32})
        set(ASSET_INSTALL_DIR ${ASSET_INSTALL_DIR_WIN32})
    endif()

    file(GLOB_RECURSE ASSET_FILES "${ASSET_SOURCE_DIR}/*")

    if(NOT ASSET_FILES)
        message(STATUS "No asset files found in ${ASSET_SOURCE_DIR}.")
        target_compile_definitions(${STANDALONE_NAME} PRIVATE ASSET_FILES="No asset files found in ${ASSET_SOURCE_DIR}.")
        return()
    endif()

    # Extract file names from paths
    set(ASSET_FILE_NAMES "")

    foreach(ASSET_FILE ${ASSET_FILES})
        get_filename_component(FILE_NAME ${ASSET_FILE} NAME)
        list(APPEND ASSET_FILE_NAMES ${FILE_NAME})
    endforeach()

    string(REPLACE ";" "," ASSET_FILE_NAMES_STR "${ASSET_FILE_NAMES}")


    if(UNIX AND NOT APPLE)
        copy_assets(${STANDALONE_NAME} "${ASSET_SOURCE_DIR}" "${ASSET_BUILD_DIR}")
        install(DIRECTORY ${ASSET_SOURCE_DIR} DESTINATION ${ASSET_INSTALL_DIR})
        target_compile_definitions(${STANDALONE_NAME} PRIVATE ASSET_PATH="../${ASSET_INSTALL_DIR}")
        target_compile_definitions(${STANDALONE_NAME} PRIVATE ASSET_FILES="${ASSET_FILE_NAMES_STR}")
    elseif(APPLE)
        copy_assets(${STANDALONE_NAME} "${ASSET_SOURCE_DIR}" "${ASSET_BUILD_DIR}")
        install(DIRECTORY ${ASSET_SOURCE_DIR} DESTINATION ${ASSET_INSTALL_DIR})
        target_compile_definitions(${STANDALONE_NAME} PRIVATE ASSET_PATH="../${ASSET_INSTALL_DIR}")
        target_compile_definitions(${STANDALONE_NAME} PRIVATE ASSET_FILES="${ASSET_FILE_NAMES_STR}")
    elseif(WIN32)
        copy_assets(${STANDALONE_NAME} "${ASSET_SOURCE_DIR}" "${ASSET_BUILD_DIR}")
        install(DIRECTORY ${ASSET_SOURCE_DIR} DESTINATION "bin/${ASSET_INSTALL_DIR}")
        target_compile_definitions(${STANDALONE_NAME} PRIVATE ASSET_PATH="${ASSET_INSTALL_DIR}")
        target_compile_definitions(${STANDALONE_NAME} PRIVATE ASSET_FILES="${ASSET_FILE_NAMES_STR}")
    endif()


    endfunction()