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
$(call inherit-product, $(SRC_TARGET_DIR)/product/non_ab_device.mk)

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
    PRODUCT_NAME=BND-AL10 \
    PRIVATE_BUILD_DESC="BND-AL10-user 9.1.0 HUAWEIBND-AL10 146-CHN-LGRP1 release-keys"

BUILD_FINGERPRINT := HONOR/BND-AL10/HWBND-H:9/HONORBND-AL10/9.1.0.146C01:user/release-keys
