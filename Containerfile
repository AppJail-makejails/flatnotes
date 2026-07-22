ARG FREEBSD_RELEASE

FROM ghcr.io/appjail-makejails/core:${FREEBSD_RELEASE}

ARG PYVER
ARG NO_PKGCLEAN

LABEL org.opencontainers.image.title="Flatnotes" \
    org.opencontainers.image.description="Self-hosted, database-less note taking web app" \
    org.opencontainers.image.source="https://github.com/AppJail-makejails/flatnotes" \
    org.opencontainers.image.url="https://github.com/AppJail-makejails/flatnotes" \
    org.opencontainers.image.vendor="DtxdF" \
    org.opencontainers.image.authors="Jesús Daniel Colmenares Oviedo <dtxdf@disroot.org>"

RUN set -xe; \
    \
    pkg update; \
    pkg install -U py${PYVER}-flatnotes; \
    \
    if [ -z "${NO_PKGCLEAN}" ]; then \
        pkg clean -a; \
        rm -rf /var/cache/pkg/*; \
    fi; \
    rm -rf /var/db/pkg/repos/*

ENV PYVER=${PYVER}
ENV FLATNOTES_HOST=0.0.0.0
ENV FLATNOTES_PORT=8080
ENV FLATNOTES_PATH=/var/db/flatnotes
ENV APP_PATH=/usr/local/www/flatnotes

VOLUME ["${FLATNOTES_PATH}"]

COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh

WORKDIR ${APP_PATH}

EXPOSE ${FLATNOTES_PORT}/tcp

ENTRYPOINT ["/entrypoint.sh"]
