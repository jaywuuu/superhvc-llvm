add_llvm_component_library(LLVMSVHCDesc
  SVHCMCTargetDesc.cpp
  SVHCMCAsmInfo.cpp

  LINK_COMPONENTS
  MC
  Support
  SVHCInfo

  ADD_TO_COMPONENT
  SVHC
)

add_dependencies(LLVMSVHCDesc SVHCCommonTableGen)
