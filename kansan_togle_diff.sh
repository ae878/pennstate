#!/bin/bash

set -e

KERNEL_DIR=~/linux-6.10
cd "$KERNEL_DIR"

echo "[1] Cleaning kernel..."
make mrproper

echo "[2] Creating default config..."
make defconfig

echo "[3] Enabling CONFIG_KASAN..."
scripts/config --enable CONFIG_KASAN
make olddefconfig
make prepare
make drivers/usb/storage/alauda.i
cp drivers/usb/storage/alauda.i printk_yes.i

echo "[4] Disabling CONFIG_KASAN..."
scripts/config --disable CONFIG_KASAN
make olddefconfig
make prepare
make drivers/usb/storage/alauda.i
cp drivers/usb/storage/alauda.i printk_no.i

echo "[5] Diffing results..."
diff -u printk_no.i printk_yes.i | less

