#!/bin/bash -e
# Check-build for proj.4
. /etc/profile.d/modules.sh
module add ci
module add cmake
cd ${WORKSPACE}/${NAME}-${VERSION}/build-${BUILD_NUMBER}
make check

echo $?

make install
mkdir -p ${REPO_DIR}
mkdir -p modules
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
    puts stderr "       This module does nothing but alert the user"
    puts stderr "       that the [module-info name] module is not available"
}

module-whatis   "$NAME $VERSION."
setenv       PROJ4_VERSION       $VERSION
setenv       PROJ4_DIR           /data/ci-build/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
prepend-path LD_LIBRARY_PATH     $::env(PROJ4_DIR)/lib
prepend-path PATH                $::env(PROJ4_DIR)/bin
prepend-path CFLAGS            "-I$::env(PROJ4_DIR/include"
prepend-path CPPFLAGS            "-I$::env(PROJ4_DIR/include"
prepend-path LDFLAGS           "-L$(PROJ4_DIR)/lib"
MODULE_FILE
) > modules/$VERSION

mkdir -p ${LIBRARIES_MODULES}/${NAME}
cp modules/$VERSION ${LIBRARIES_MODULES}/${NAME}
