#!/bin/sh

BASEDIR=`dirname -- "$0"` || exit $?
BASEDIR=`realpath -- "${BASEDIR}"` || exit $?

. "${BASEDIR}/update.conf"

set -xe
set -o pipefail

cat -- "${BASEDIR}/Makejail.template" |\
    sed -Ee "s/%%TAG1%%/${TAG1}/g" > "${BASEDIR}/../Makejail"

cat -- "${BASEDIR}/build.makejail.template" |\
    sed -Ee "s/%%PYVER%%/${PYVER}/g" > "${BASEDIR}/../build.makejail"

cat -- "${BASEDIR}/download-flatnotes.makejail.template" |\
    sed -Ee "s/%%VERSION%%/${VERSION}/g" > "${BASEDIR}/../download-flatnotes.makejail"

cat -- "${BASEDIR}/README.md.template" |\
    sed -E \
        -e "s/%%TAG1%%/${TAG1}/g" \
        -e "s/%%TAG2%%/${TAG2}/g" \
        -e "s/%%VERSION%%/${VERSION}/g" > "${BASEDIR}/../README.md"
