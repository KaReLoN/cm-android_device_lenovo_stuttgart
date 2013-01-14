#
# Copyright (C) 2012 The CyanogenMod Project
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

LOCAL_PATH := $(call my-dir)

$(INSTALLED_BOOTIMAGE_TARGET): $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_FILES) $(MKIMAGE)
	$(call pretty,"Target K860 boot image: $@")
	$(hide) $(MKIMAGE) -A ARM -O Linux -T ramdisk -C none -a 40000000 -e 40000000 -n ramdisk -d $(INSTALLED_RAMDISK_TARGET) $(INSTALLED_RAMDISK_TARGET).uboot
	@mv $(INSTALLED_RAMDISK_TARGET).uboot $(INSTALLED_RAMDISK_TARGET)
	$(hide) $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_ARGS) --output $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_BOOTIMAGE_PARTITION_SIZE),raw)
	@echo -e ${CL_CYN}"Made boot image: $@"${CL_RST}

$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG) $(MKIMAGE) \
		$(recovery_ramdisk) \
		$(recovery_kernel)
	@echo -e ${CL_CYN}"----- Making K860 recovery image ------"${CL_RST}
	$(MKIMAGE) -A ARM -O Linux -T ramdisk -C none -a 40000000 -e 40000000 -n ramdisk -d $(recovery_ramdisk) $(recovery_ramdisk).uboot
	@mv $(recovery_ramdisk).uboot $(recovery_ramdisk)
	$(MKBOOTIMG) $(INTERNAL_RECOVERYIMAGE_ARGS) --output $@
	@echo -e ${CL_CYN}"Made K860 recovery image: $@"${CL_RST}
	$(hide) $(call assert-max-image-size,$@,$(BOARD_RECOVERYIMAGE_PARTITION_SIZE),raw)
