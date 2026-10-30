#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

BOND_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function blob_fixup() {
    case "${1}" in
        odm/etc/camera/*.xml)
	    sed -i 's/gb2312/iso-8859-1/g' "${2}"
	    sed -i 's/GB2312/iso-8859-1/g' "${2}"
	    sed -i 's/xmlversion/xml version/g' "${2}"
            ;;
        vendor/firmware/isp_dts.img)
            python3 "${BOND_DIR}/tools/trim_isp_dts.py" "${2}" "${2}" BOND
            ;;
    esac
}

# If we're being sourced by the common script that we called,
# stop right here. No need to go down the rabbit hole.
if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    return
fi

set -e

export DEVICE=bond
export DEVICE_COMMON=hi6250-9-common
export VENDOR=huawei

MY_DIR="${BASH_SOURCE%/*}"
if [ ! -d "${MY_DIR}" ]; then
    MY_DIR="${PWD}"
fi
ANDROID_ROOT="${MY_DIR}/../../.."

case " ${*} " in
    *" --isp "* )
        command -v python3 > /dev/null || { echo "python3 is required" >&2; exit 1; }

        ISP_TMP="$(mktemp -d)"
        trap 'rm -rf "${ISP_TMP}"' EXIT

        adb pull /vendor/firmware/isp_dts.img "${ISP_TMP}/isp_dts.img"
        python3 "${MY_DIR}/tools/trim_isp_dts.py" \
            "${ISP_TMP}/isp_dts.img" \
            "${ANDROID_ROOT}/vendor/${VENDOR}/${DEVICE}/proprietary/vendor/firmware/isp_dts.img" \
            BOND
        exit
        ;;
esac

"./../../${VENDOR}/${DEVICE_COMMON}/extract-files.sh" "$@"
