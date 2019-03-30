export THEOS_DEVICE_IP=192.168.178.39
export SDKROOT=iphoneos
export SYSROOT=$(THEOS)/sdks/iPhoneOS11.2.sdk
export PACKAGE_VERSION=0.0.1
export TARGET = iphone::latest
export ARCHS = arm64
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = WallpaperFix
WallpaperFix_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Preferences"
