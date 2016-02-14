#!/bin/bash -e
# Proj.4 deploy script
# this should be run after check-build finishes.

. /etc/profile.d/modules.sh
echo ${SOFT_DIR}
module add deploy
echo ${SOFT_DIR}
cd ${WORKSPACE}/${NAME}-${VERSION}/
echo "All tests have passed, will now build into ${SOFT_DIR}"
make distclean
./configure --prefix=${SOFT_DIR}
make install -j2
echo "Creating the modules file directory ${LIBRARIES_MODULES}"
mkdir -p ${LIBRARIES_MODULES}/${NAME}
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
    puts stderr "       This module does nothing but alert the user"
    puts stderr "       that the [module-info name] module is not available"
}

module-whatis   "$NAME $VERSION : See https://github.com/SouthAfricaDigitalScience/gmp-deploy"
setenv PROJ4_VERSION       $VERSION
setenv PROJ4_DIR           $::env(CVMFS_DIR)/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
prepend-path LD_LIBRARY_PATH     $::env(PROJ4_DIR)/lib
prepend-path PATH                $::env(PROJ4_DIR)/bin
prepend-path CFLAGS            "-I${PROJ4_DIR}/include"
prepend-path LDFLAGS           "-L${PROJ4_DIR}/lib"
MODULE_FILE
) > ${LIBRARIES_MODULES}/${NAME}/${VERSION}
