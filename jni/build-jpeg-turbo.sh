#!/bin/bash

ndk-build APP_ABI=armeabi,armeabi-v7a,x86,arm64-v8a,x86_64 APP_PLATFORM=android-9 APP_BUILD_SCRIPT=./Android-jpeg-turbo.mk APP_PROJECT_PATH=../ NDK_LIBS_OUT=../shared-jpegturbo/libs APP_OPTIM=release -j 8
rm -rf ../obj