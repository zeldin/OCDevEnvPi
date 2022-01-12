#!/bin/sh -e

install -m 644 -t "${ROOTFS_DIR}/etc/udev/rules.d/" files/*.rules
