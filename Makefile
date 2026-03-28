# Makefile
# Theos build configuration for YTTweak
#
# Prerequisites:
#   - Theos installed: https://theos.dev/docs/installation
#   - iOS SDK (via Xcode or theos-jailed)
#   - set THEOS environment variable to your Theos install path
#
# Usage:
#   make            - Build the tweak .dylib and .deb package
#   make package    - Build a .deb for Cydia / Sileo / Zebra distribution
#   make install    - Deploy to a connected jailbroken device over SSH

# ── Target platform ─────────────────────────────────────────────────────────
ARCHS = arm64 arm64e
TARGET = iphone:clang:16.5:14.0

# ── Theos boilerplate ────────────────────────────────────────────────────────
include $(THEOS)/makefiles/common.mk

# ── Tweak definition ─────────────────────────────────────────────────────────
TWEAK_NAME = YTTweak

# Source files (Logos pre-processor handles .x → .mm → .o)
YTTweak_FILES = \
    YTTweak.x \
    Settings.x \
    Sideloading.x

# Compiler flags
YTTweak_CFLAGS  = -fobjc-arc -Wno-unused-variable
YTTweak_CCFLAGS = -std=c++17

# Link frameworks
YTTweak_FRAMEWORKS = \
    UIKit \
    Foundation \
    AVFoundation \
    StoreKit

# ── Filter: only inject into the YouTube app ─────────────────────────────────
# (Matches the bundle ID of the sideloaded / App Store YouTube app)
YTTweak_BUNDLE_ID = com.google.ios.youtube

include $(THEOS_MAKE_PATH)/tweak.mk

# ── After-install hook: respring on device ───────────────────────────────────
after-install::
	install.exec "killall -9 YouTube || true"
