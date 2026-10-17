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
e-m:e-p:16:16-i32:16-i64:16-f32:16-f64:16-a:8-n8:16-S16
```
| Specifier | Description |
| :--- | :--- |
| `e` | Little-endian byte order |
| `m:e` | ELF-style symbol mangling |
| `p:16:16` | 16-bit pointers with 16-bit ABI alignment in address space 0 |
| `i32:16` | 32-bit integers aligned to 16-bit boundaries |
| `i64:16` | 64-bit integers aligned to 16-bit boundaries |
| `f32:16` | 32-bit floating point numbers aligned to 16-bit boundaries |
| `f64:16` | 64-bit floating point numbers aligned to 16-bit boundaries |
| `a:8` | Minimum aggregate alignment of 8 bits (1 byte) |
| `n8:16` | Native CPU integer register widths (8-bit and 16-bit operations) |
| `S16` | Stack pointer aligned to 16 bits (2 bytes) |

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
To configure CMake to include the experimental SVHC target and clang:
```bash
cmake -S llvm -B build -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_ENABLE_PROJECTS="clang" \
  -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD="SVHC" \
  -DLLVM_USE_LINKER=lld \
  -DLLVM_CCACHE_BUILD=ON \
  -DLLVM_OPTIMIZED_TS_TABLEGEN=ON
ninja -C build -j4
```

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
