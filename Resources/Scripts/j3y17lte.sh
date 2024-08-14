#!/bin/bash

# Build an Android kernel that is actually UEFI disguised as the Kernel
cat ./BootShim/AARCH64/BootShim.bin "./Build/j3y17ltePkg/${_TARGET_BUILD_MODE}_CLANGPDB/FV/J3Y17LTE_UEFI.fd" > ./Resources/bootpayload.bin || exit 1 #"./Build/j3y17ltePkg/${_TARGET_BUILD_MODE}_CLANGPDB/FV/J3Y17LTE_UEFI.fd-bootshim"||exit 1
#gzip -c < "./Build/j3y17ltePkg/${_TARGET_BUILD_MODE}_CLANGPDB/FV/J3Y17LTE_UEFI.fd-bootshim" > "./Build/j3y17ltePkg/${_TARGET_BUILD_MODE}_CLANGPDB/FV/J3Y17LTE_UEFI.fd-bootshim.gz"||exit 1
#cat "./Build/j3y17ltePkg/${_TARGET_BUILD_MODE}_CLANGPDB/FV/J3Y17LTE_UEFI.fd-bootshim" ./Resources/DTBs/j3y17lte.dtb > ./Resources/bootpayload.bin||exit 1

# Create a Bootable Android Boot Image
python3 ./Resources/Scripts/mkbootimg.py \
  --kernel ./Resources/bootpayload.bin \
  --ramdisk ./Resources/ramdisk \
  --dtb ./Resources/DTBs/j3y17lte.dtb \
  --kernel_offset 0x00000000 \
  --ramdisk_offset 0x01000000 \
  --tags_offset 0x00000100 \
  --dtb_offset 0x00000000 \
  --os_version 11.0.0 \
  --os_patch_level "$(date '+%Y-%m')" \
  --header_version 1 \
  -o "boot.img" \
  ||_error "\nFailed to create Android Boot Image!\n"s


# Compress Boot Image in a tar File for Odin/heimdall Flash
tar -c boot.img -f Mu-j3y17lte.tar||exit 1
mv boot.img Mu-j3y17lte.img||exit 1
