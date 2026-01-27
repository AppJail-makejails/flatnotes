FLATNOTES_HOST="${FLATNOTES:-0.0.0.0}"
FLATNOTES_PORT="${FLATNOTES_PORT:-8080}"
FLATNOTES_PATH="/var/db/flatnotes"; export FLATNOTES_PATH

cd /usr/local/www/flatnotes &&
daemon \
    -t "Database-less note taking web app" \
    -p /var/run/flatnotes.pid \
    -u www \
    -S \
        uvicorn \
        main:app \
          --app-dir server \
          --host "${FLATNOTES_HOST}" \
          --port "${FLATNOTES_PORT}" \
          --proxy-headers \
          --forwarded-allow-ips '*'
