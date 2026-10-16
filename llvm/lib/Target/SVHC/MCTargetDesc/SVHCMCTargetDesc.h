//===-- SVHCMCTargetDesc.h - SVHC Target Descriptions -----------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_SVHC_MCTARGETDESC_SVHCMCTARGETDESC_H
#define LLVM_LIB_TARGET_SVHC_MCTARGETDESC_SVHCMCTARGETDESC_H

#include "llvm/Support/DataTypes.h"

namespace llvm {
class Target;

Target &getTheSVHCTarget();

} // namespace llvm

// Defines symbolic names for SVHC registers.
#define GET_REGINFO_ENUM
#include "SVHCGenRegisterInfo.inc"

// Defines symbolic names for SVHC instructions.
#define GET_INSTRINFO_ENUM
#include "SVHCGenInstrInfo.inc"

#define GET_SUBTARGETINFO_ENUM
#include "SVHCGenSubtargetInfo.inc"

#endif // LLVM_LIB_TARGET_SVHC_MCTARGETDESC_SVHCMCTARGETDESC_H
