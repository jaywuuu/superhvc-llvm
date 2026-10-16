//===--- SVHC.cpp - Implement SVHC target feature support -----------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements SVHC TargetInfo objects.
//
//===----------------------------------------------------------------------===//

#include "SVHC.h"
#include "clang/Basic/MacroBuilder.h"

using namespace clang;
using namespace clang::targets;

const char *const SVHCTargetInfo::GCCRegNames[] = {
    "a", "x", "y", "sp", "dp", "pc", "pbr", "dbr", "p"
};

ArrayRef<const char *> SVHCTargetInfo::getGCCRegNames() const {
  return llvm::ArrayRef(GCCRegNames);
}

void SVHCTargetInfo::getTargetDefines(const LangOptions &Opts,
                                      MacroBuilder &Builder) const {
  Builder.defineMacro("__svhc__");
  Builder.defineMacro("__SVHC__");
  Builder.defineMacro("__snes__");
  Builder.defineMacro("__SNES__");
  Builder.defineMacro("__w65c816__");
}
