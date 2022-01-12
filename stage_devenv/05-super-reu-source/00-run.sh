#!/bin/sh -e

git clone https://github.com/zeldin/super-reu "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/super-reu"
chown -Rh --reference="${ROOTFS_DIR}/home/${FIRST_USER_NAME}" "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/super-reu"
(echo ""; echo "export TARGET=orangecart") >> "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.bashrc"
