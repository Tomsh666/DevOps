#!/bin/bash

block_device=$1
if lsblk -o NAME,MOUNTPOINT | grep "$(basename "$block_device")" | grep -q "/"; then
        exit 90
fi

temp_dir=$(mktemp -d)
mount "$block_device" "$temp_dir"