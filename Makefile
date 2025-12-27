# Makefile for SpadesX Plugin Development
# Cross-platform build system wrapper around CMake

# ============================================================================
# Configuration
# ============================================================================

PLUGIN_NAME ?= my_plugin
PLUGIN_SOURCE ?= template_plugin.c
BUILD_DIR := build
CMAKE := cmake
MAKE_CMD := $(MAKE)

# Detect OS
ifeq ($(OS),Windows_NT)
    PLUGIN_EXT := .dll
    RM := del /Q
    RMDIR := rmdir /S /Q
    MKDIR := mkdir
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),Darwin)
        PLUGIN_EXT := .dylib
    else
        PLUGIN_EXT := .so
    endif
    RM := rm -f
    RMDIR := rm -rf
    MKDIR := mkdir -p
endif

# ============================================================================
# Targets
# ============================================================================

.PHONY: all plugin clean distclean install help test

# Default target
all: plugin

# Configure and build plugin
plugin:
	@echo "Building plugin: $(PLUGIN_NAME)"
	@$(MKDIR) $(BUILD_DIR)
	@cd $(BUILD_DIR) && \
		$(CMAKE) .. \
			-DPLUGIN_NAME=$(PLUGIN_NAME) \
			-DPLUGIN_SOURCE=$(PLUGIN_SOURCE) && \
		$(CMAKE) --build . --config Release
	@echo ""
	@echo "✓ Plugin built successfully!"
	@echo "  Output: $(BUILD_DIR)/plugins/$(PLUGIN_NAME)$(PLUGIN_EXT)"

# Build in debug mode
debug:
	@echo "Building plugin in debug mode: $(PLUGIN_NAME)"
	@$(MKDIR) $(BUILD_DIR)
	@cd $(BUILD_DIR) && \
		$(CMAKE) .. \
			-DCMAKE_BUILD_TYPE=Debug \
			-DPLUGIN_NAME=$(PLUGIN_NAME) \
			-DPLUGIN_SOURCE=$(PLUGIN_SOURCE) && \
		$(CMAKE) --build . --config Debug
	@echo ""
	@echo "✓ Debug plugin built successfully!"
	@echo "  Output: $(BUILD_DIR)/plugins/$(PLUGIN_NAME)$(PLUGIN_EXT)"

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@$(RMDIR) $(BUILD_DIR) 2>/dev/null || true
	@echo "✓ Clean complete"

# Deep clean (including downloaded headers)
distclean: clean
	@echo "Removing downloaded API headers..."
	@$(RM) PluginAPI.h 2>/dev/null || true
	@echo "✓ Deep clean complete"

# Install plugin to system (optional)
install: plugin
	@echo "Installing plugin..."
	@cd $(BUILD_DIR) && $(CMAKE) --install .
	@echo "✓ Plugin installed"

# Test build (verify it compiles)
test: plugin
	@echo "✓ Build test passed"

# Display help
help:
	@echo "SpadesX Plugin Development Makefile"
	@echo ""
	@echo "Usage:"
	@echo "  make [target] [PLUGIN_NAME=name] [PLUGIN_SOURCE=file.c]"
	@echo ""
	@echo "Targets:"
	@echo "  all          - Build plugin (default)"
	@echo "  plugin       - Build plugin in release mode"
	@echo "  debug        - Build plugin in debug mode"
	@echo "  clean        - Remove build artifacts"
	@echo "  distclean    - Deep clean (includes downloaded headers)"
	@echo "  install      - Install plugin to system"
	@echo "  test         - Test that plugin builds successfully"
	@echo "  help         - Show this help message"
	@echo ""
	@echo "Variables:"
	@echo "  PLUGIN_NAME    - Name of the plugin (default: my_plugin)"
	@echo "  PLUGIN_SOURCE  - Source file to build (default: template_plugin.c)"
	@echo ""
	@echo "Examples:"
	@echo "  make                                      # Build template_plugin"
	@echo "  make PLUGIN_NAME=my_gamemode              # Build with custom name"
	@echo "  make PLUGIN_NAME=ctf PLUGIN_SOURCE=ctf.c  # Build custom plugin"
	@echo "  make debug                                # Build in debug mode"
	@echo "  make clean && make                        # Clean rebuild"
	@echo ""
