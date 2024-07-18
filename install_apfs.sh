#!/usr/bin/env bash

# Gabriel Staples
# 20 May 2023

# Install a linux kernel APFS Apple Filesystem module to allow us
# to mount and read Apple AFPS drives.
# See my instructions online: 
# https://github.com/linux-apfs/linux-apfs-rw/issues/42#issuecomment-1556103266
install_apfs() {
    STARTING_DIR="$(pwd)"

    sudo add-apt-repository universe -y
    sudo apt update
    sudo DEBIAN_FRONTEND=noninteractive apt install -y \
        linux-headers-$(uname -r) \
        git \
        gcc \
        g++ \
        cmake \
        make \
        ncdu

    mkdir -p ~/dev
    cd ~/dev
    git clone https://github.com/linux-apfs/linux-apfs-rw.git
    cd linux-apfs-rw
    time make
    sudo modprobe libcrc32c
    sudo insmod apfs.ko

    cd "$STARTING_DIR"

    echo "Done installing linux-apfs-rw kernel module"\
         "to allow you to mount and read Apple APFS filesystems!"
}

install_all() {
    time install_apfs "$@"
}

# Determine if the script is being sourced or executed (run).
# See:
# 1. "eRCaGuy_hello_world/bash/if__name__==__main___check_if_sourced_or_executed_best.sh"
# 1. My answer: https://stackoverflow.com/a/70662116/4561887
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
    # This script is being run.
    __name__="__main__"
else
    # This script is being sourced.
    __name__="__source__"
fi

# Only run `main` if this script is being **run**, NOT sourced (imported).
# - See my answer: https://stackoverflow.com/a/70662116/4561887
if [ "$__name__" = "__main__" ]; then
    time install_all "$@"
fi
