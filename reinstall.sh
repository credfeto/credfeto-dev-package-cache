#! /bin/bash

exec {lock_fd}>/tmp/devpkg || exit 1

/bin/flock -n "$lock_fd" || { echo "ERROR: flock() failed." >&2; exit 1; }


sudo docker compose stop && sudo docker compose rm --force && sudo rm -fr /cache/nuget/db/* && sudo rm -fr /cache/nginx/* && ./update
