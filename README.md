# Flatnotes

Flatnotes is a self-hosted, database-less note-taking web app that utilises a flat folder of markdown files for storage.

github.com/dullage/flatnotes

<img src="https://github.com/dullage/flatnotes/raw/develop/docs/logo.svg" width="30%" height="auto" alt="Flatnotes logo">

## How to use this Makejail

### Standalone

```console
$ appjail oci run -Pd \
    -o overwrite=force \
    -o virtualnet=":<random> default" \
    -o nat \
    -e PUID=15000 \
    -e PGID=15000 \
    -e FLATNOTES_AUTH_TYPE=none \
    ghcr.io/appjail-makejails/flatnotes flatnotes
```

### Deploy using `appjail-director`

```yaml
options:
  - virtualnet: ':<random> default'
  - nat:

services:
  flatnotes:
    makejail: gh+AppJail-makejails/flatnotes
    options:
      - container: 'boot args:--pull'
    volumes:
      - data: /var/db/flatnotes
    oci:
      environment:
        - PUID: 1000
        - PGID: 1000
        - FLATNOTES_AUTH_TYPE: "password"
        - FLATNOTES_USERNAME: "user"
        - FLATNOTES_PASSWORD: "changeMe!"
        - FLATNOTES_SECRET_KEY: "aLongRandomSeriesOfCharacters"

volumes:
  data:
    device: /var/appjail-volumes/flatnotes/data
```

See the [Environment Variables](https://github.com/dullage/flatnotes/wiki/Environment-Variables) article in the wiki for a full list of configuration options.

### Arguments (stage: build)

* `flatnotes_from` (default: `ghcr.io/appjail-makejails/flatnotes`): Location of OCI image. See also [OCI Configuration](#oci-configuration).
* `flatnotes_tag` (default: `latest`): OCI image tag. See also [OCI Configuration](#oci-configuration).

### Environment (OCI image)

* `PGID` (default: `1000`): Equivalent to `PUID` but for the Process Group ID.
* `PUID` (default: `1000`): Process User ID for the container's main process, allowing you to match the owner of files written to mounted host volumes to your host system's user. Writable volumes are changed based on this environment variable.

### Volumes

| Name | Owner | Group | Perm | Type | Mountpoint |
| --- | --- | --- | --- | --- | --- |
| appjail-f797226ec7-var_db_flatnotes | `${PUID}` | `${PGID}` | - | - | /var/db/flatnotes |

## OCI Configuration

```yaml
build:
  variants:
    - tag: 15.1
      containerfile: Containerfile
      aliases: ["latest"]
      default: true
      args:
        FREEBSD_RELEASE: "15.1"
        PYVER: "312"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
```
