#!/bin/sh

. /lib.subr

[ "$FLATNOTES_HOST" ] || FLATNOTES_HOST=0.0.0.0
[ "$FLATNOTES_PORT" ] || FLATNOTES_PORT=8080

set -e
set -o pipefail

python_version=`printf "%s" "${PYVER}" | sed -Ee 's/([0-9])([0-9]+)/\1.\2/'`
python_cmd="/usr/local/bin/python${python_version}"

create_user

flatnotes_command="${python_cmd} -m \
                  uvicorn \
                  main:app \
                  --app-dir server \
                  --host ${FLATNOTES_HOST} \
                  --port ${FLATNOTES_PORT} \
                  --proxy-headers \
                  --forwarded-allow-ips '*'"

echo Setting file permissions...
chown -R noroot:noroot ${FLATNOTES_PATH} ${APP_PATH}

echo Starting flatnotes as user ${PUID}...
exec su-exec noroot ${flatnotes_command}
