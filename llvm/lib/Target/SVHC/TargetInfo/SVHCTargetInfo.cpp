//===-- SVHCTargetInfo.cpp - SVHC Target Implementation -------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "TargetInfo/SVHCTargetInfo.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/Compiler.h"

using namespace llvm;

Target &llvm::getTheSVHCTarget() {
  static Target TheSVHCTarget;
  return TheSVHCTarget;
}

extern "C" LLVM_ABI LLVM_EXTERNAL_VISIBILITY void
LLVMInitializeSVHCTargetInfo() {
  RegisterTarget<Triple::svhc> X(getTheSVHCTarget(), "svhc",
                                 "Super Home Video Computer", "SVHC");
}
