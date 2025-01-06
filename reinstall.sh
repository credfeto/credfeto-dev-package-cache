#! /bin/sh

sudo docker compose stop && sudo docker compose rm --force && sudo rm -fr /cache/nuget/db/* && /bin/flock -n /tmp/devpkg.lock -c /home/markr/work/credfeto-dev-package-cache/update
