add_llvm_component_library(LLVMSVHCInfo
  SVHCTargetInfo.cpp

  LINK_COMPONENTS
  MC
  Support

  ADD_TO_COMPONENT
  SVHC
)
