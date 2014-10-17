#!/bin/sh

cd `dirname $0`
SCRIPTDIR=`pwd`
WCMDIR=${SCRIPTDIR}/../wcm/
SCRIPTNAME=`basename $0`

WCM_VERSION=`awk '($2 ~ /WCM_VERSION/) {gsub(/"/,"",$3); print $3}'` < ${WCMDIR}/wcm-version.h

if [ -z "`head -1 ${SCRIPTDIR}/changelog | grep ${WCM_VERSION}`" ]
then
    echo "Error: Update ${SCRIPTDIR}/changelog with version ${WCM_VERSION}, and its changes"
    exit 3
fi


case "$1" in
  build)
	cd ${WCMDIR}
	make clean
	${SCRIPTDIR}/${SCRIPTNAME} clean
	cd ${WCMDIR}/..
	cd ..
	tar czf wcm_${WCM_VERSION}.orig.tar.gz WalCommander/wcm
	# --exclude=.git --exclude=build --exclude=libssh
	cd ${WCMDIR}/..
	dpkg-buildpackage -b -us -uc
  ;;
  clean)
	cd ${SCRIPTDIR}
	rm -rf wcm
	rm -f *.log
	rm -f files
	rm -f wcm.substvars
	rm -f ../../wcm_${WCM_VERSION}*
  ;;
  *)
    echo "Usage: $0 {build|clean}" >&2
    exit 2
  ;;
esac

