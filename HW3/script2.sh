#!/bin/bash

read -p "Enter filename: " filename
touch $filename
read -p "Enter file permissions:(example: 777, 666) " file_perms
chmod $file_perms $filename