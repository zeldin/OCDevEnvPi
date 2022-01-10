FROM debian:bullseye

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update && \
    apt-get -y install --no-install-recommends \
        git vim parted fdisk \
        quilt coreutils qemu-user-static debootstrap zerofree zip dosfstools \
        libarchive-tools libcap2-bin rsync grep udev xz-utils curl xxd file kmod bc\
        binfmt-support ca-certificates qemu-utils kpartx \
    && rm -rf /var/lib/apt/lists/*

COPY pi-gen /pi-gen/
RUN sed -i -e 's:modprobe:test -b /dev/nbd0 || &:' /pi-gen/scripts/qcow2_handling

VOLUME [ "/pi-gen/work", "/pi-gen/deploy"]
