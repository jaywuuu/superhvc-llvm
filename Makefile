# ==============================================================================
# Makefile Wrapper for LLVM / Clang Build
# ==============================================================================

# Auto-detect Host Architecture for LLVM and CPU cores
UNAME_M := $(shell uname -m)

ifeq ($(UNAME_M), x86_64)
    HOST_TARGET := X86
else ifneq (,$(findstring arm,$(UNAME_M)))
    HOST_TARGET := AArch64
else ifeq ($(UNAME_M), aarch64)
    HOST_TARGET := AArch64
else
    HOST_TARGET := X86  # Fallback default
endif

ifeq ($(shell uname), Darwin)
    CORES ?= $(shell sysctl -n hw.ncpu)
else
    CORES ?= $(shell nproc 2>/dev/null || echo 4)
endif

# Build configuration
BUILD_TYPE ?= RelWithDebInfo
BUILD_DIR  ?= build
JOBS       ?= $(CORES)


# LLVM CMake options
LLVM_SRC_DIR                       ?= llvm
LLVM_ENABLE_PROJECTS               ?= clang
LLVM_TARGETS_TO_BUILD							 ?= $(HOST_TARGET)
LLVM_EXPERIMENTAL_TARGETS_TO_BUILD ?= SVHC
LLVM_USE_LINKER                    ?= lld
LLVM_CCACHE_BUILD                  ?= ON
LLVM_OPTIMIZED_TS_TABLEGEN         ?= ON
CMAKE_EXTRA_FLAGS                  ?=

# Test configuration
TEST_TARGET                        ?= check-all

# Target to build with Ninja (empty by default builds all)
TARGET                             ?=

# Stamp file to track the current configured build type
CONFIG_STAMP := $(BUILD_DIR)/.configured_$(BUILD_TYPE)

.PHONY: all build configure reconfigure release relwithdebinfo debug \
        test check check-all check-llvm check-clang clean distclean help

# Default target
all: build

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------
$(CONFIG_STAMP):
	@mkdir -p $(BUILD_DIR)
	cmake -S $(LLVM_SRC_DIR) -B $(BUILD_DIR) -G Ninja \
		-DCMAKE_BUILD_TYPE=$(BUILD_TYPE) \
		-DLLVM_ENABLE_PROJECTS="$(LLVM_ENABLE_PROJECTS)" \
		-DLLVM_TARGETS_TO_BUILD="$(LLVM_TARGETS_TO_BUILD)" \
		-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD="$(LLVM_EXPERIMENTAL_TARGETS_TO_BUILD)" \
		-DLLVM_USE_LINKER=$(LLVM_USE_LINKER) \
		-DLLVM_CCACHE_BUILD=$(LLVM_CCACHE_BUILD) \
		-DLLVM_OPTIMIZED_TS_TABLEGEN=$(LLVM_OPTIMIZED_TS_TABLEGEN) \
		$(CMAKE_EXTRA_FLAGS)
	@rm -f $(BUILD_DIR)/.configured_*
	@touch $(CONFIG_STAMP)

configure:
	@rm -f $(BUILD_DIR)/.configured_*
	@$(MAKE) $(CONFIG_STAMP)

reconfigure: configure

# ------------------------------------------------------------------------------
# Build Targets
# ------------------------------------------------------------------------------
build: $(CONFIG_STAMP)
	ninja -C $(BUILD_DIR) -j$(JOBS) $(TARGET)

release:
	@$(MAKE) build BUILD_TYPE=Release

relwithdebinfo:
	@$(MAKE) build BUILD_TYPE=RelWithDebInfo

debug:
	@$(MAKE) build BUILD_TYPE=Debug

# ------------------------------------------------------------------------------
# Testing Targets
# ------------------------------------------------------------------------------
test: $(CONFIG_STAMP)
	ninja -C $(BUILD_DIR) -j$(JOBS) $(TEST_TARGET)

check: test

check-all: $(CONFIG_STAMP)
	ninja -C $(BUILD_DIR) -j$(JOBS) check-all

check-llvm: $(CONFIG_STAMP)
	ninja -C $(BUILD_DIR) -j$(JOBS) check-llvm

check-clang: $(CONFIG_STAMP)
	ninja -C $(BUILD_DIR) -j$(JOBS) check-clang

# ------------------------------------------------------------------------------
# Clean Targets
# ------------------------------------------------------------------------------
clean:
	@if [ -f $(BUILD_DIR)/build.ninja ]; then \
		ninja -C $(BUILD_DIR) clean; \
	fi

distclean:
	rm -rf $(BUILD_DIR)

# ------------------------------------------------------------------------------
# Help
# ------------------------------------------------------------------------------
help:
	@echo "LLVM Build Makefile Wrapper"
	@echo "==========================="
	@echo "Usage: make [target] [VARIABLES...]"
	@echo ""
	@echo "Build Targets:"
	@echo "  all             Build project using BUILD_TYPE (default: RelWithDebInfo)"
	@echo "  build           Alias for 'all'"
	@echo "  release         Build with -DCMAKE_BUILD_TYPE=Release"
	@echo "  relwithdebinfo  Build with -DCMAKE_BUILD_TYPE=RelWithDebInfo"
	@echo "  debug           Build with -DCMAKE_BUILD_TYPE=Debug"
	@echo ""
	@echo "Test Targets:"
	@echo "  test            Run tests via Ninja (default: check-all)"
	@echo "  check           Alias for 'test'"
	@echo "  check-all       Run all tests (LLVM + Clang)"
	@echo "  check-llvm      Run LLVM tests only"
	@echo "  check-clang     Run Clang tests only"
	@echo ""
	@echo "Maintenance Targets:"
	@echo "  configure       Run CMake configuration"
	@echo "  reconfigure     Force CMake reconfiguration"
	@echo "  clean           Run ninja clean"
	@echo "  distclean       Remove $(BUILD_DIR) directory completely"
	@echo "  help            Show this help text"
	@echo ""
	@echo "Configurable Variables:"
	@echo "  BUILD_TYPE      Build type: RelWithDebInfo | Release | Debug (default: $(BUILD_TYPE))"
	@echo "  BUILD_DIR       Build directory (default: $(BUILD_DIR))"
	@echo "  JOBS            Parallel jobs for ninja (default: $(JOBS))"
	@echo "  TEST_TARGET     Ninja target to run on 'make test' (default: $(TEST_TARGET))"
	@echo "  TARGET          Specific build target to compile (e.g. make TARGET=clang)"
	@echo "  CMAKE_EXTRA_FLAGS Extra flags to forward to CMake"
