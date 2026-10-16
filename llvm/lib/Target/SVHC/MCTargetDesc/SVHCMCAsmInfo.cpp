//===-- SVHCMCAsmInfo.cpp - SVHC asm properties ---------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "SVHCMCAsmInfo.h"
#include "llvm/TargetParser/Triple.h"

using namespace llvm;

void SVHCMCAsmInfo::anchor() {}

SVHCMCAsmInfo::SVHCMCAsmInfo(const Triple &TT, const MCTargetOptions &Options)
    : MCAsmInfoELF(Options) {
  CodePointerSize = 2;
  CalleeSaveStackSlotSize = 2;
  CommentString = ";";
  AlignmentIsInBytes = false;
  UsesELFSectionDirectiveForBSS = true;
  SupportsDebugInformation = true;
}
