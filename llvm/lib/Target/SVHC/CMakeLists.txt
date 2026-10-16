add_llvm_component_group(SVHC)

set(LLVM_TARGET_DEFINITIONS SVHC.td)

tablegen(LLVM SVHCGenInstrInfo.inc -gen-instr-info)
tablegen(LLVM SVHCGenRegisterInfo.inc -gen-register-info)
tablegen(LLVM SVHCGenSubtargetInfo.inc -gen-subtarget)

add_public_tablegen_target(SVHCCommonTableGen)

add_llvm_target(SVHCCodeGen
  SVHCTargetMachine.cpp

  LINK_COMPONENTS
  CodeGen
  Core
  MC
  Support
  Target
  TargetParser
  SVHCDesc
  SVHCInfo

  ADD_TO_COMPONENT
  SVHC
  )

add_subdirectory(MCTargetDesc)
add_subdirectory(TargetInfo)
