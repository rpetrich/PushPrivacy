TWEAK_NAME = PushPrivacy
PushPrivacy_FILES = Tweak.x
PushPrivacy_FRAMEWORKS = UIKit

ADDITIONAL_CFLAGS = -std=c99

SDKVERSION := 5.1
TARGET_IPHONEOS_DEPLOYMENT_VERSION := 5.0

include framework/makefiles/common.mk
include framework/makefiles/tweak.mk
