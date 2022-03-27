PRJTRELLIS_VERSION=1.2.1
DATABASE_HASH=0ee729d
git clone -b ${PRJTRELLIS_VERSION} https://github.com/YosysHQ/prjtrellis.git
cd prjtrellis/database
git clone https://github.com/YosysHQ/prjtrellis-db .
git checkout ${DATABASE_HASH}
cd ../libtrellis
export pkg_version=${PRJTRELLIS_VERSION}
export pkg_arch=$(dpkg --print-architecture)
cmake -DCMAKE_INSTALL_PREFIX=/usr .
make
make install DESTDIR=$(pwd)/../prjtrellis_${pkg_version}_${pkg_arch}
cd ..
mkdir prjtrellis_${pkg_version}_${pkg_arch}/DEBIAN
cat > prjtrellis_${pkg_version}_${pkg_arch}/DEBIAN/control <<EOF
Package: prjtrellis
Version: ${pkg_version}
Section: base
Priority: optional
Architecture: ${pkg_arch}
Maintainer: Marcus Comstedt <marcus@mc.pp.se>
Depends: libboost-filesystem1.74.0, libboost-program-options1.74.0, libboost-thread1.74.0, libboost-atomic1.74.0
Description: Project Trellis packaged for OrangeCartridge development environment
 This is an upstream build of Project Trellis, specially packaged for the OrangeCartridge devleopment environment.
EOF
dpkg-deb --build prjtrellis_${pkg_version}_${pkg_arch}
cd ..
