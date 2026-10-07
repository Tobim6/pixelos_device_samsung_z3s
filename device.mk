#
# Copyright (C) 2019 The LineageOS Project
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

# Audio
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/audio/mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml

$(call soong_config_set_bool,universal9830AudioVars,use_bta2dp_offload,false)
$(call soong_config_set_bool,universal9830AudioVars,use_quad_mic,true)
$(call soong_config_set_bool,universal9830AudioVars,use_camcorder_quad_mic,false)

# Bluetooth
$(call soong_config_set,brcm_libbt,custom_bt_config,//$(LOCAL_PATH):vnd_exynos9830.txt)

PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.0-impl:64 \
    android.hardware.bluetooth@1.0-service \
    libbt-vendor:64

# Boot Animation
TARGET_SCREEN_HEIGHT := 3200
TARGET_SCREEN_WIDTH := 1440

# Camera
$(call soong_config_set,samsungCameraVars,extra_ids,52) # ID=52 is telephoto

# Density mapping config
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/display/display_id_4633128672291735937.xml:$(TARGET_COPY_OUT_VENDOR)/etc/displayconfig/display_id_4633128672291735937.xml

# NFC
# TEST: neither open-source community HAL (hardware_samsung_slsi_nfc nor the older
# hardware_samsung_nfc) can complete a raw Mifare Classic frame exchange -- a frida
# trace on /dev/sec-nfc traffic showed the exact same generic failure response for
# every command type (auth, read, even RATS, which a real Classic card never answers),
# with both HALs, confirming the bug is in their raw-Mifare-interface code itself, not
# any config value (NFA_PROPRIETARY_CFG is byte-identical to stock's). The one thing
# confirmed working is Samsung's own real stock binary, extracted from the device's
# actual stock firmware (AP_extracted) -- wiring that in directly instead of either
# community reimplementation. z3s-specific: the blob/module only exists in
# vendor/samsung/z3s, so this cannot live in the shared device-common.mk.
PRODUCT_PACKAGES += \
    sec.android.hardware.nfc@1.2-service

# Overlays
PRODUCT_PACKAGES += \
    FrameworkResOverlayDevice \
    SettingsOverlayDevice \
    SettingsProviderOverlayDevice \
    SystemUIOverlayDevice \
    WiFiOverlayDevice

# Sensors
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/sensors/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH) \
    hardware/broadcom/libbt

# WiFi
PRODUCT_PACKAGES += \
    android.hardware.wifi-service \
    hostapd \
    wpa_supplicant \
    wpa_supplicant.conf \
    wifi_brcm.rc \
    wifi_sec.rc

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/wifi/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf \
    $(LOCAL_PATH)/configs/wifi/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf

$(call soong_config_set_bool,wpa_supplicant_8,board_wlan_bcmdhd_sae,true)

# Inherit from Hubble
$(call inherit-product, device/samsung/universal9830-common/device-hubble.mk)

# Inherit from the proprietary version
$(call inherit-product-if-exists, vendor/samsung/z3s/z3s-vendor.mk)
