//===-- SVHCMCTargetDesc.cpp - SVHC Target Descriptions -------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "SVHCMCTargetDesc.h"
#include "SVHCMCAsmInfo.h"
#include "TargetInfo/SVHCTargetInfo.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/Compiler.h"

#define GET_INSTRINFO_MC_DESC
#include "SVHCGenInstrInfo.inc"

#define GET_SUBTARGETINFO_MC_DESC
#include "SVHCGenSubtargetInfo.inc"

#define GET_REGINFO_MC_DESC
#include "SVHCGenRegisterInfo.inc"

using namespace llvm;

static MCInstrInfo *createSVHCMCInstrInfo() {
  MCInstrInfo *X = new MCInstrInfo();
  InitSVHCMCInstrInfo(X);
  return X;
}

static MCRegisterInfo *createSVHCMCRegisterInfo(const Triple &TT) {
  MCRegisterInfo *X = new MCRegisterInfo();
  InitSVHCMCRegisterInfo(X, SVHC::PC);
  return X;
}

static MCSubtargetInfo *
createSVHCMCSubtargetInfo(const Triple &TT, StringRef CPU, StringRef FS) {
  return createSVHCMCSubtargetInfoImpl(TT, CPU, /*TuneCPU=*/CPU, FS);
}

static MCAsmInfo *createSVHCMCAsmInfo(const MCRegisterInfo &MRI,
                                      const Triple &TT,
                                      const MCTargetOptions &Options) {
  return new SVHCMCAsmInfo(TT, Options);
}

extern "C" LLVM_ABI LLVM_EXTERNAL_VISIBILITY void LLVMInitializeSVHCTargetMC() {
  Target &T = getTheSVHCTarget();

  TargetRegistry::RegisterMCAsmInfo(T, createSVHCMCAsmInfo);
  TargetRegistry::RegisterMCInstrInfo(T, createSVHCMCInstrInfo);
  TargetRegistry::RegisterMCRegInfo(T, createSVHCMCRegisterInfo);
  TargetRegistry::RegisterMCSubtargetInfo(T, createSVHCMCSubtargetInfo);
}
