# Super Home Video Computer Compiler

This repo is a fork of LLVM and contains the backend target for the Super Home Video Computer!

Okay, it's really just the SNES/SFC (Ricoh 5A22 / WDC 65816 CPU).

## SVHC Target Overview

### Target Triples
* **Canonical Bare-Metal Triple:** `svhc-unknown-none-elf` *(Recommended for SNES ROM / firmware dev)*
* **Generic Triple:** `svhc-unknown-unknown-elf`
* **Shorthand:** `svhc` (e.g., `llc -mtriple=svhc input.ll -o output.s`)

### Data Layout Specification
```text
e-m:e-p:16:8-p1:24:8-i16:8-i24:8-i32:8-i64:8-f32:8-f64:8-a:8-n8:16-S8
```
| Specifier | Description |
| :--- | :--- |
| `e` | Little-endian byte order |
| `m:e` | ELF-style symbol mangling |
| `p:16:8` | 16-bit pointers with 8-bit ABI alignment in address space 0 (near pointers) |
| `p1:24:8` | 24-bit pointers with 8-bit ABI alignment in address space 1 (far pointers) |
| `i16:8` | 16-bit integers aligned to 8-bit boundaries (byte-aligned) |
| `i24:8` | 24-bit integers aligned to 8-bit boundaries (byte-aligned) |
| `i32:8` | 32-bit integers aligned to 8-bit boundaries (byte-aligned) |
| `i64:8` | 64-bit integers aligned to 8-bit boundaries (byte-aligned) |
| `f32:8` | 32-bit floating point numbers aligned to 8-bit boundaries |
| `f64:8` | 64-bit floating point numbers aligned to 8-bit boundaries |
| `a:8` | Minimum aggregate alignment of 8 bits (1 byte) |
| `n8:16` | Native CPU integer register widths (8-bit and 16-bit operations) |
| `S8` | Stack pointer aligned to 8 bits (1 byte) |

### Directory Structure
The SVHC backend is housed under `llvm/lib/Target/SVHC/`:

```text
llvm/lib/Target/SVHC/
├── CMakeLists.txt                # Builds SVHCCodeGen & drives TableGen
├── SVHC.h                        # Target-wide declarations
├── SVHC.td                       # Top-level TableGen target definition (processors & ISA)
├── SVHCInstrFormats.td           # Instruction formats & pseudo-instructions
├── SVHCInstrInfo.td              # TableGen instruction descriptions
├── SVHCRegisterInfo.td           # 65816 registers (A, X, Y, SP, DP, PC, PBR, DBR, P)
├── SVHCTargetMachine.h           # SVHCTargetMachine class declaration
├── SVHCTargetMachine.cpp         # TargetMachine implementation & registration
├── MCTargetDesc/                 # Machine Code (MC) layer
│   ├── CMakeLists.txt            # Builds LLVMSVHCDesc
│   ├── SVHCMCAsmInfo.h           # Assembly info header
│   ├── SVHCMCAsmInfo.cpp         # Assembly syntax, comments, pointer sizes
│   ├── SVHCMCTargetDesc.h        # Enums for registers, instructions, and subtarget
│   └── SVHCMCTargetDesc.cpp      # TargetRegistry registrations for MC layer
└── TargetInfo/                   # Target discovery & registration
    ├── CMakeLists.txt            # Builds LLVMSVHCInfo
    ├── SVHCTargetInfo.h          # Target declaration (getTheSVHCTarget)
    └── SVHCTargetInfo.cpp        # Target registration with LLVM TargetRegistry
```

### Building the Target

A Makefile wrapper is provided at the repository root to simplify configuration, compilation, and testing.

#### Quick Start (Default: RelWithDebInfo, 4 parallel jobs)
```bash
make
```

#### Build Types
The Makefile defaults to `RelWithDebInfo`, and supports `Release` and `Debug`:
```bash
# RelWithDebInfo (default)
make relwithdebinfo

# Release
make release

# Debug
make debug

# Or override via BUILD_TYPE
make BUILD_TYPE=Debug
```

#### Running Tests
```bash
# Run all regression tests (LLVM + Clang)
make test

# Run LLVM regression tests only
make check-llvm

# Run Clang regression tests only
make check-clang
```

#### Common Workflow Options
```bash
# Build a specific target only (e.g. llc or clang)
make TARGET=llc

# Adjust parallel compilation jobs (default: 4)
make JOBS=8

# Force re-running CMake configuration
make configure

# Clean build artifacts or remove build directory
make clean
make distclean

# Show all available targets and variables
make help
```

> **Note on TableGen (`.td`) changes:** Editing any TableGen file (e.g., `SVHC.td`, `SVHCInstrInfo.td`, `SVHCRegisterInfo.td`) does **not** require reconfiguring CMake. Simply run `make` (or `make TARGET=llc`); Ninja automatically detects TableGen dependency changes, regenerates the corresponding `.inc` files, and recompiles affected C++ files.

<details>
<summary>Manual CMake Command (Under the Hood)</summary>

If you prefer running CMake and Ninja directly:
```bash
cmake -S llvm -B build -G Ninja \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DLLVM_ENABLE_PROJECTS="clang" \
  -DLLVM_TARGETS_TO_BUILD="X86" \
  -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD="SVHC" \
  -DLLVM_USE_LINKER=lld \
  -DLLVM_CCACHE_BUILD=ON \
  -DLLVM_OPTIMIZED_TS_TABLEGEN=ON
ninja -C build -j4
```
</details>

---

# The LLVM Compiler Infrastructure

[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/llvm/llvm-project/badge)](https://securityscorecards.dev/viewer/?uri=github.com/llvm/llvm-project)
[![OpenSSF Best Practices](https://www.bestpractices.dev/projects/8273/badge)](https://www.bestpractices.dev/projects/8273)
[![libc++](https://github.com/llvm/llvm-project/actions/workflows/libcxx-pr-conformance-tests.yaml/badge.svg?branch=main&event=schedule)](https://github.com/llvm/llvm-project/actions/workflows/libcxx-pr-conformance-tests.yaml?query=event%3Aschedule)

Welcome to the LLVM project!

This repository contains the source code for LLVM, a toolkit for the
construction of highly optimized compilers, optimizers, and run-time
environments.

The LLVM project has multiple components. The core of the project is
itself called "LLVM". This contains all of the tools, libraries, and header
files needed to process intermediate representations and convert them into
object files. Tools include an assembler, disassembler, bitcode analyzer, and
bitcode optimizer.

C-like languages use the [Clang](https://clang.llvm.org/) frontend. This
component compiles C, C++, Objective-C, and Objective-C++ code into LLVM bitcode
-- and from there into object files, using LLVM.

Other components include:
the [libc++ C++ standard library](https://libcxx.llvm.org),
the [LLD linker](https://lld.llvm.org), and more.

## Getting the Source Code and Building LLVM

Consult the
[Getting Started with LLVM](https://llvm.org/docs/GettingStarted.html#getting-the-source-code-and-building-llvm)
page for information on building and running LLVM.

For information on how to contribute to the LLVM project, please take a look at
the [Contributing to LLVM](https://llvm.org/docs/Contributing.html) guide.

## Getting in touch

Join the [LLVM Discourse forums](https://discourse.llvm.org/), [Discord
chat](https://discord.gg/xS7Z362),
[LLVM Office Hours](https://llvm.org/docs/GettingInvolved.html#office-hours) or
[Regular sync-ups](https://llvm.org/docs/GettingInvolved.html#online-sync-ups).

The LLVM project has adopted a [code of conduct](https://llvm.org/docs/CodeOfConduct.html) for
participants to all modes of communication within the project.
