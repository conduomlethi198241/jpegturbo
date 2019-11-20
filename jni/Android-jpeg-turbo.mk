LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)
JPEGTURBO_CFLAGS := -D__STDC_LIMIT_MACROS -D__STDC_CONSTANT_MACROS -Wno-attributes
JPEGTURBO_DIR := ../libjpeg-turbo/
JPEGTURBO_SRC_FILES := \
	jcapimin.c jcapistd.c jccoefct.c jccolor.c \
	jcdctmgr.c jchuff.c jcinit.c jcmainct.c jcmarker.c jcmaster.c \
	jcomapi.c jcparam.c jcphuff.c jcprepct.c jcsample.c jctrans.c \
	jdapimin.c jdapistd.c jdatadst.c jdatasrc.c jdcoefct.c jdcolor.c \
	jddctmgr.c jdhuff.c jdinput.c jdmainct.c jdmarker.c jdmaster.c \
	jdmerge.c jdphuff.c jdpostct.c jdsample.c jdtrans.c jerror.c \
	jfdctflt.c jfdctfst.c jfdctint.c jidctflt.c jidctfst.c jidctint.c \
	jidctred.c jquant1.c jquant2.c jutils.c jmemmgr.c \
	jaricom.c jcarith.c jdarith.c \
	transupp.c jmemnobs.c

# switch between SIMD supported and non supported architectures
ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
JPEGTURBO_SRC_FILES += \
	simd/jsimd_arm_neon.S.neon \
	simd/jsimd_arm.c
else
JPEGTURBO_SRC_FILES += jsimd_none.c
endif

JPEGTURBO_SRC_FILES := $(addprefix $(JPEGTURBO_DIR), $(JPEGTURBO_SRC_FILES))
#$(info $(JPEGTURBO_SRC_FILES))
EXPORT_HEADERS := jpeglib.h jmorecfg.h jconfig.h

ifeq ($(TARGET_ARCH_ABI),arm64-v8a x86_64)
	JPEGTURBO_CFLAGS += -DSIZEOF_SIZE_T=8
else
	JPEGTURBO_CFLAGS += -DSIZEOF_SIZE_T=4
endif

# jpegturbo module
include $(CLEAR_VARS)
LOCAL_MODULE:= jpegturbo
LOCAL_CFLAGS := $(JPEGTURBO_CFLAGS)
LOCAL_SRC_FILES := $(JPEGTURBO_SRC_FILES)
LOCAL_COPY_HEADERS_TO := ../shared-includes
LOCAL_COPY_HEADERS := $(addprefix $(JPEGTURBO_DIR), $(EXPORT_HEADERS))
include $(BUILD_SHARED_LIBRARY)



all: $(LOCAL_PATH)/../lib/$(notdir $(LOCAL_BUILT_MODULE))

$(LOCAL_PATH)/../lib/$(notdir $(LOCAL_BUILT_MODULE)): $(LOCAL_BUILT_MODULE)
	cp $(wildcard $(JPEGTURBO_DIR)/*.h ../shared-jpegturbo/includes)