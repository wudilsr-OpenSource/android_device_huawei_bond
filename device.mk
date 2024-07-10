
# Copyright (C) 2022 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

## Device Path
DEVICE_PATH := device/huawei/bond

PRODUCT_IS_TABLET := true

## Inherit common device
$(call inherit-product, device/huawei/hi6250-9-common/common.mk)

## Inherit vendor blobs
$(call inherit-product, vendor/huawei/bond/bond-vendor.mk)

# Display
TARGET_SCREEN_DENSITY := 480
TARGET_SCREEN_HEIGHT := 2160
TARGET_SCREEN_WIDTH := 1080

# Init
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/rootdir/etc/bond.rc:$(TARGET_COPY_OUT_ODM)/etc/init/bond.rc

# Overlays
PRODUCT_PACKAGES += \
    FrameworksResOverlayBond \
    WifiResOverlayBond

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += $(DEVICE_PATH)
