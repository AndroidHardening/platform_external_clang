LOCAL_PATH := $(call my-dir)
CLANG_ROOT_PATH := $(LOCAL_PATH)

FORCE_BUILD_LLVM_DISABLE_NDEBUG ?= false
# Legality check: FORCE_BUILD_LLVM_DISABLE_NDEBUG should consist of one word -- either "true" or "false".
ifneq "$(words $(FORCE_BUILD_LLVM_DISABLE_NDEBUG))$(words $(filter-out true false,$(FORCE_BUILD_LLVM_DISABLE_NDEBUG)))" "10"
  $(error FORCE_BUILD_LLVM_DISABLE_NDEBUG may only be true, false, or unset)
endif

FORCE_BUILD_LLVM_DEBUG ?= false
# Legality check: FORCE_BUILD_LLVM_DEBUG should consist of one word -- either "true" or "false".
ifneq "$(words $(FORCE_BUILD_LLVM_DEBUG))$(words $(filter-out true false,$(FORCE_BUILD_LLVM_DEBUG)))" "10"
  $(error FORCE_BUILD_LLVM_DEBUG may only be true, false, or unset)
endif

.PHONY: clang-toolchain llvm-tools
clang-toolchain: \
    asan_test \
    clang \
    clang-check \
    clang-format \
    clang-tidy \
    FileCheck \
    llvm-as \
    llvm-dis \
    llvm-link \
    LLVMgold \
    libprofile_rt

llvm-tools: \
    bugpoint \
    BugpointPasses \
    count \
    llc \
    lli \
    lli-child-target \
    LLVMHello \
    llvm-ar \
    llvm-as \
    llvm-bcanalyzer \
    llvm-config \
    llvm-cov \
    llvm-c-test \
    llvm-cxxdump \
    llvm-diff \
    llvm-dis \
    llvm-dsymutil \
    llvm-dwarfdump \
    llvm-dwp \
    llvm-extract \
    llvm-link \
    llvm-lto \
    llvm-mc \
    llvm-mcmarkup \
    llvm-nm \
    llvm-objdump \
    llvm-pdbdump \
    llvm-profdata \
    llvm-readobj \
    llvm-rtdyld \
    llvm-size \
    llvm-split \
    llvm-symbolizer \
    not \
    obj2yaml \
    opt \
    sancov \
    sanstats \
    verify-uselistorder \
    yaml2obj \
    yaml-bench

ifneq ($(HOST_OS),darwin)
clang-toolchain: \
    libasan \
    libasan_32 \
    libasan_cxx \
    libasan_cxx_32 \
    libprofile_rt_32 \
    libtsan \
    libtsan_cxx \
    libubsan_standalone \
    libubsan_standalone_32 \
    libubsan_standalone_cxx \
    libubsan_standalone_cxx_32

#    host_cross_clang \
#    host_cross_clang_64 \

# Build libomp on Linux host.  Build modules for the host and some specific
# targets.
clang-toolchain: libomp
ifneq (,$(filter arm arm64 x86 x86_64,$(TARGET_ARCH)))
clang-toolchain: libomp-$(TARGET_ARCH)
endif # ifneq  (,$(filter arm arm64 x86 x86_64,$(TARGET_ARCH)))

endif # ifneq ($(HOST_OS),darwin)

ifneq (,$(filter arm arm64 x86 mips mips64,$(TARGET_ARCH)))
clang-toolchain: \
    $(ADDRESS_SANITIZER_RUNTIME_LIBRARY)

endif

include $(CLEAR_VARS)

subdirs := $(addprefix $(LOCAL_PATH)/,$(addsuffix /Android.mk, \
  lib/Analysis \
  lib/AST \
  lib/ASTMatchers \
  lib/ARCMigrate \
  lib/Basic \
  lib/CodeGen \
  lib/Driver \
  lib/Edit \
  lib/Format \
  lib/Frontend \
  lib/Frontend/Rewrite \
  lib/FrontendTool \
  lib/Index \
  lib/Lex \
  lib/Parse \
  lib/Rewrite \
  lib/Sema \
  lib/Serialization \
  lib/StaticAnalyzer/Checkers \
  lib/StaticAnalyzer/Core \
  lib/StaticAnalyzer/Frontend \
  lib/Tooling \
  lib/Tooling/Core \
  tools/clang-check \
  tools/clang-format \
  tools/driver \
  tools/libclang \
  utils/TableGen \
  ))

include $(LOCAL_PATH)/clang.mk
include $(LOCAL_PATH)/shared_clang.mk

include $(subdirs)
