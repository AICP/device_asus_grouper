# Copyright (C) 2010 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# This file is the build configuration for a full Android
# build for grouper hardware. This cleanly combines a set of
# device-specific aspects (drivers) with a device-agnostic
# product configuration (apps).
#

# Inherit from those products. Most specific first.
$(call inherit-product, device/asus/grouper/device.mk)
$(call inherit-product, vendor/asus/grouper/asus-vendor.mk)
$(call inherit-product, vendor/broadcom/grouper/broadcom-vendor.mk)
$(call inherit-product, vendor/elan/grouper/elan-vendor.mk)
$(call inherit-product, vendor/invensense/grouper/invensense-vendor.mk)
$(call inherit-product, vendor/nvidia/grouper/nvidia-vendor.mk)
$(call inherit-product, vendor/nxp/grouper/nxp-vendor.mk)
$(call inherit-product, vendor/widevine/grouper/widevine-vendor.mk)
# This is where we'd set a backup provider if we had one
#$(call inherit-product, device/sample/products/backup_overlay.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base.mk)

# Discard inherited values and use our own instead.
PRODUCT_NAME := full_grouper
PRODUCT_DEVICE := grouper
PRODUCT_BRAND := Android
PRODUCT_MODEL := AOSP on Grouper
