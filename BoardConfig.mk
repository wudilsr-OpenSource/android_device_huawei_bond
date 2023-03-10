#
# Copyright (C) 2022 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

## Device Path
DEVICE_PATH := device/huawei/bond

## Include common BoardConfig
include device/huawei/hi6250-9-common/BoardConfigCommon.mk

# Partitions
BOARD_BOOTIMAGE_PARTITION_SIZE     := 25165824   # mmcblk0p31 (24576*1024)
BOARD_CACHEIMAGE_PARTITION_SIZE    := 134217728  # mmcblk0p43 (131072*1024)
BOARD_ODMIMAGE_PARTITION_SIZE      := 134217728  # mmcblk0p44 (131072*1024)
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 33554432   # mmcblk0p33 (32768*1024)
BOARD_SYSTEMIMAGE_PARTITION_SIZE   := 3724541952 # mmcblk0p52 (3637248*1024)
BOARD_PRODUCTIMAGE_PARTITION_SIZE  := 620756992  # mmcblk0p56 (606208*1024)
BOARD_VENDORIMAGE_PARTITION_SIZE   := 822083584  # mmcblk0p55 (802816*1024)

#cust    mmcblk0p53 196608
