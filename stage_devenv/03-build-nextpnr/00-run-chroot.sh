NEXTPNR_VERSION=0.3
git clone -b nextpnr-${NEXTPNR_VERSION} https://github.com/YosysHQ/nextpnr.git
cd nextpnr
export pkg_version=${NEXTPNR_VERSION}
export pkg_arch=$(dpkg --print-architecture)
cmake -DARCH=ecp5 -DTRELLIS_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_PREFIX=/usr -DCURRENT_GIT_VERSION=${NEXTPNR_VERSION} .
make
make DESTDIR=$(pwd)/nextpnr-ecp5_${pkg_version}_${pkg_arch} install/strip
mkdir nextpnr-ecp5_${pkg_version}_${pkg_arch}/DEBIAN
cat > nextpnr-ecp5_${pkg_version}_${pkg_arch}/DEBIAN/control <<EOF
Package: nextpnr-ecp5
Version: ${pkg_version}
Section: base
Priority: optional
Architecture: ${pkg_arch}
Maintainer: Marcus Comstedt <marcus@mc.pp.se>
Depends: libboost-regex1.74.0
Description: nextpnt-ecp5 packaged for OrangeCartridge development environment
 This is an upstream build of nextpnr, specially packaged for the OrangeCartridge devleopment environment.
EOF
dpkg-deb --build nextpnr-ecp5_${pkg_version}_${pkg_arch}
cd ..
