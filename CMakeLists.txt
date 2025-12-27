# CMakeLists.txt for SpadesX Plugin Template
# This template allows building plugins standalone without the full server source

cmake_minimum_required(VERSION 3.10)
project(SpadesXPlugin VERSION 1.0.0 LANGUAGES C)

# ============================================================================
# Configuration
# ============================================================================

# Plugin name (change this to your plugin name)
set(PLUGIN_NAME "my_plugin" CACHE STRING "Plugin name")

# Source file (change this to your plugin source file)
set(PLUGIN_SOURCE "template_plugin.c" CACHE STRING "Plugin source file")

# SpadesX API header location
# Option 1: Use local copy (default)
# Option 2: Download from repository
set(SPADESX_API_HEADER "${CMAKE_CURRENT_SOURCE_DIR}/PluginAPI.h" CACHE FILEPATH "Path to PluginAPI.h")

# ============================================================================
# Download API header if not present
# ============================================================================

if(NOT EXISTS "${SPADESX_API_HEADER}")
    message(STATUS "PluginAPI.h not found, downloading from GitHub...")
    file(DOWNLOAD
        "https://raw.githubusercontent.com/SpadesX/SpadesX/master/Source/Server/PluginAPI.h"
        "${CMAKE_CURRENT_SOURCE_DIR}/PluginAPI.h"
        SHOW_PROGRESS
        STATUS download_status
    )
    list(GET download_status 0 status_code)
    if(NOT status_code EQUAL 0)
        message(WARNING "Failed to download PluginAPI.h. Please manually copy it to the project directory.")
    else()
        set(SPADESX_API_HEADER "${CMAKE_CURRENT_SOURCE_DIR}/PluginAPI.h")
    endif()
endif()

# ============================================================================
# Compiler Settings
# ============================================================================

# Use C11 standard
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

# Compiler flags (MSVC vs GCC/Clang)
if(MSVC)
    # MSVC compiler flags
    add_compile_options(
        /W4                              # Warning level 4
        $<$<CONFIG:Debug>:/Zi>          # Debug info
        $<$<CONFIG:Release>:/O2>        # Optimize for speed
    )
else()
    # GCC/Clang compiler flags
    add_compile_options(
        -Wall
        -Wextra
        $<$<CONFIG:Debug>:-g>
        $<$<CONFIG:Release>:-O2>
    )
endif()

# Include directory for API header
include_directories(${CMAKE_CURRENT_SOURCE_DIR})

# ============================================================================
# Build Plugin as Shared Library
# ============================================================================

add_library(${PLUGIN_NAME} SHARED ${PLUGIN_SOURCE})

# Platform-specific compilation flags
if(NOT MSVC)
    target_compile_options(${PLUGIN_NAME} PRIVATE
        -fvisibility=default
        $<$<PLATFORM_ID:Linux>:-fPIC>
    )
endif()

# Set properties
set_target_properties(${PLUGIN_NAME} PROPERTIES
    PREFIX ""  # No 'lib' prefix
    POSITION_INDEPENDENT_CODE ON
)

# Platform-specific library extension
if(WIN32)
    set_target_properties(${PLUGIN_NAME} PROPERTIES SUFFIX ".dll")
elseif(APPLE)
    set_target_properties(${PLUGIN_NAME} PROPERTIES SUFFIX ".dylib")
else()
    set_target_properties(${PLUGIN_NAME} PROPERTIES SUFFIX ".so")
endif()

# Output directory
set_target_properties(${PLUGIN_NAME} PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/plugins"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/plugins"
    ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/plugins"
)

# ============================================================================
# Installation
# ============================================================================

install(TARGETS ${PLUGIN_NAME}
    LIBRARY DESTINATION plugins
    RUNTIME DESTINATION plugins
)

# ============================================================================
# Info
# ============================================================================

message(STATUS "==============================================")
message(STATUS "SpadesX Plugin Build Configuration")
message(STATUS "==============================================")
message(STATUS "Plugin Name:    ${PLUGIN_NAME}")
message(STATUS "Source File:    ${PLUGIN_SOURCE}")
message(STATUS "API Header:     ${SPADESX_API_HEADER}")
message(STATUS "Build Type:     ${CMAKE_BUILD_TYPE}")
message(STATUS "==============================================")
