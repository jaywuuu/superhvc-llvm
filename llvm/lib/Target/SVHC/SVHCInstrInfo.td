//===-- SVHCInstrInfo.td - SVHC Instruction Information ----*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

include "SVHCInstrFormats.td"

//===----------------------------------------------------------------------===//
// Instructions
//===----------------------------------------------------------------------===//

def NOP : SVHCInst<(outs), (ins), "nop", []> {
  let Inst{7-0} = 0xea;
}
