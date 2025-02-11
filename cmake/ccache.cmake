include(${CMAKE_CURRENT_LIST_DIR}/CPM.cmake)
function(apply_ccache TARGET)
    if(ENABLE_CCACHE)
        message(STATUS "Using ccache for target ${TARGET}")
        # https://ccache.dev
        # adding via https://github.com/TheLartians/Ccache.cmake
        CPMAddPackage("gh:TheLartians/Ccache.cmake@1.2.5")
    endif()
endfunction()
