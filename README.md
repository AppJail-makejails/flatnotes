# Flatnotes

Flatnotes is a self-hosted, database-less note-taking web app that utilises a flat folder of markdown files for storage.

flatnotes.io

<img src="https://github.com/dullage/flatnotes/raw/develop/docs/logo.svg" alt="flatnotes logo" width="80%" height="auto">

## Features

* Mobile responsive web interface.
* Raw/WYSIWYG markdown editor modes.
* Advanced search functionality.
* Note "tagging" functionality.
* Wikilink support to easily link to other notes (`[[My Other Note]]`).
* Light/dark themes.
* Multiple authentication options (none, read-only, username/password, 2FA).
* Restful API.

## How to use this Makejail

### Standalone

```
appjail makejail \
    -j flatnotes \
    -f gh+AppJail-makejails/flatnotes \
    -o virtualnet=":<random> default" \
    -o nat \
    -o expose=8080
appjail start -V FLATNOTES_AUTH_TYPE=none flatnotes
```

### Deploy using appjail-director

```yaml
options:
  - virtualnet: ':<random> default'
  - nat:

services:
  flatnotes:
    name: flatnotes
    makejail: gh+AppJail-makejails/flatnotes
    options:
      - expose: 8080
    start-environment:
      - FLATNOTES_AUTH_TYPE: 'none'
    volumes:
      - flatnotes-data: flatnotes-data

default_volume_type: '<volumefs>'

volumes:
  flatnotes-data:
    device: .volumes/data
```

### Arguments (stage: build):

* `flatnotes_tag` (default: `13.5`): See [#tags](#tags).
* `flatnotes_ajspec` (default: `gh+AppJail-makejails/flatnotes`): Entry point where the `appjail-ajspec(5)` file is located.

### Check current status

The custom stage `flatnotes_status` can be used to run `top(1)` to check the status of Flatnotes.

```sh
appjail run -s flatnotes_status flatnotes
```

### Log

To view the log generated by the web application, run the custom stage `flatnotes_log`.

```sh
appjail run -s flatnotes_log flatnotes
```

### Volumes

| Name           | Owner | Group | Perm | Type | Mountpoint       |
| -------------- | ----- | ----- | ---- | ---- | ---------------- |
| flatnotes-data | 1001  | 1001  |  -   |  -   | /flatnotes/data  |

### Healthcheckers

* `check_jail`:
  - **description**: Check if the jail is running and restart it if it is not.
  - **options**:
    - `health_cmd`: `host:appjail status -q %j`
    - `recover_cmd`: `host:appjail restart %j`
* `check_pid`:
  - **description**: Check if the PID file exists and the process is still running and restart the jail if it does not.
  - **options**:
    - `health_cmd`: `jail:/healthcheckers/pid_file.sh`
    - `recover_cmd`: `host:appjail restart %j`

## Tags

| Tag        | Arch    | Version            | Type   | `flatnotes_version` |
| ---------- | ------- | ------------------ | ------ | ------------------- |
| `13.5` | `amd64` | `13.5-RELEASE` | `thin` | `3.6.1`       |
| `14.3` | `amd64` | `14.3-RELEASE` | `thin` | `3.6.1`       |
