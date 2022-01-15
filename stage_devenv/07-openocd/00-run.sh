#!/bin/sh -e

install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.openocd"
install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.openocd/interface"
install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.openocd/board"
install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.openocd/fpga"
install -v -o 1000 -g 1000 -m 644 -t "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.openocd" files/openocd.cfg
install -v -o 1000 -g 1000 -m 644 -t "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.openocd/interface" files/interface/*.cfg
install -v -o 1000 -g 1000 -m 644 -t "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.openocd/board" files/board/*.cfg
install -v -o 1000 -g 1000 -m 644 -t "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.openocd/fpga" files/fpga/*.cfg
echo 'gpio=24=pu' >> "${ROOTFS_DIR}/boot/config.txt"
