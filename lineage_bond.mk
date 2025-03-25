#
# Copyright (C) 2022-2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

## Common
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/product_launched_with_p.mk)

## Device
$(call inherit-product, device/huawei/bond/device.mk)

## LineageOS
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Device identifier
PRODUCT_NAME := lineage_bond
PRODUCT_DEVICE := bond
PRODUCT_BRAND := HUAWEI
PRODUCT_MODEL := Honor 7X
PRODUCT_MANUFACTURER := HUAWEI
PRODUCT_GMS_CLIENTID_BASE := android-huawei

# Use the latest approved GMS identifiers
PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_NAME=BND \
    PRIVATE_BUILD_DESC="BND-L21-user 9.1.0 HUAWEIBND-L21 164-LGRP2-OVS release-keys"

BUILD_FINGERPRINT := HONOR/BND-L21/HWBND-H:9/HONORBND-L21/9.1.0.141C432:user/release-keys
