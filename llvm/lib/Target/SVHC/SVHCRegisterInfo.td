//===-- SVHCRegisterInfo.td - SVHC Register defs -----------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
//  Declarations that describe the SVHC register file
//===----------------------------------------------------------------------===//

class SVHCReg<bits<16> Enc, string n, list<string> alt = []> : Register<n> {
  let HWEncoding = Enc;
  let Namespace = "SVHC";
  let AltNames = alt;
}

// 16-bit registers (65816 CPU)
def A  : SVHCReg<0, "a">,  DwarfRegNum<[0]>;
def X  : SVHCReg<1, "x">,  DwarfRegNum<[1]>;
def Y  : SVHCReg<2, "y">,  DwarfRegNum<[2]>;
def SP : SVHCReg<3, "sp">, DwarfRegNum<[3]>;
def DP : SVHCReg<4, "dp">, DwarfRegNum<[4]>;
def PC : SVHCReg<5, "pc">, DwarfRegNum<[5]>;

// 8-bit bank registers & status
def PBR : SVHCReg<6, "pbr">, DwarfRegNum<[6]>;
def DBR : SVHCReg<7, "dbr">, DwarfRegNum<[7]>;
def P   : SVHCReg<8, "p">,   DwarfRegNum<[8]>;

// Register classes
// Each specialized register gets its own class so LLVM knows they aren't interchangeable.
// Accumulator
def ACC : RegisterClass<"SVHC", [i16, i8], 16, (add A)>;

// Combined Index Class
def IDXR : RegisterClass<"SVHC", [i16, i8], 16, (add X, Y)>;

// Stack Pointer and Direct Page
def SPR : RegisterClass<"SVHC", [i16], 16, (add SP)>;
def DPR : RegisterClass<"SVHC", [i16], 16, (add DP)>;

// Program Counter
def PCR : RegisterClass<"SVHC", [i16], 16, (add PC)>;
