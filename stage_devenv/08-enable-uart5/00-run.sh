#!/bin/sh -e

cat >> "${ROOTFS_DIR}/boot/config.txt" <<EOF

[pi4]
dtoverlay=uart5

[all]
EOF
