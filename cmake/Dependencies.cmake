# ---- Package Manager ----
CPMAddPackage("gh:TheLartians/PackageProject.cmake@1.12.0")

if(NOT PackageProject.cmake_ADDED)
    message(FATAL_ERROR "Failed to add PackageProject.cmake")
endif()

# ---- Add fmt ----
CPMAddPackage("gh:fmtlib/fmt#11.0.2")

if(NOT fmt_ADDED)
    message(FATAL_ERROR "Failed to add fmt")
endif()

# ---- Licenses ----
CPMAddPackage("gh:cpm-cmake/CPMLicenses.cmake@0.0.7")

if(NOT CPMLicenses.cmake_ADDED)
    message(FATAL_ERROR "Failed to add CPMLicenses.cmake")
else()
    cpm_licenses_create_disclaimer_target(
        write-licenses-${PROJECT_LIBRARY_NAME} "${CMAKE_CURRENT_BINARY_DIR}/third_party.txt"
        "${CPM_PACKAGES}"
    )
endif()

# ---- Add EmojiTools ----
CPMAddPackage(
    NAME EmojiToolsLib
    GITHUB_REPOSITORY tomasmark79/EmojiTools
    GIT_TAG main
    OPTIONS "EMOJI_INSTALL NO"
)

# if(NOT EmojiToolsLib_ADDED)
#     message(FATAL_ERROR "Failed to add EmojiTools")
# else()
#     target_link_libraries(${PROJECT_LIBRARY_NAME} PUBLIC EmojiToolsLib)
# endif()
