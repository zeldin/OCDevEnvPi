YOSYS_VERSION=0.15
git clone -b yosys-${YOSYS_VERSION} https://github.com/YosysHQ/yosys.git
cd yosys
export pkg_version=${YOSYS_VERSION}
export pkg_arch=$(dpkg --print-architecture)
make config-gcc
make ENABLE_READLINE=0 PREFIX=/usr PREFIX=/usr
make install ENABLE_READLINE=0 PREFIX=/usr DESTDIR=$(pwd)/yosys_${pkg_version}_${pkg_arch}
mkdir yosys_${pkg_version}_${pkg_arch}/DEBIAN
cat > yosys_${pkg_version}_${pkg_arch}/DEBIAN/control <<EOF
Package: yosys
Version: ${pkg_version}
Section: base
Priority: optional
Architecture: ${pkg_arch}
Maintainer: Marcus Comstedt <marcus@mc.pp.se>
Depends: libtcl8.6 (>= 8.6)
Description: Yosys packaged for OrangeCartridge development environment
 This is an upstream build of Yosys, specially packaged for the OrangeCartridge devleopment environment.
EOF
dpkg-deb --build yosys_${pkg_version}_${pkg_arch}
cd ..
