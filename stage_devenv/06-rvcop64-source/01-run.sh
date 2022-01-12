#!/bin/sh -e

git clone --recurse-submodules https://github.com/zeldin/RVCop64 "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/RVCop64"
chown -Rh --reference="${ROOTFS_DIR}/home/${FIRST_USER_NAME}" "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/RVCop64"
