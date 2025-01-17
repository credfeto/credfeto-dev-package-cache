#! /bin/bash

die() {
    echo
    echo "$@"
    exit 1
}


exec {lock_fd}>/tmp/devpkg || exit 1

/bin/flock -n "$lock_fd" || { echo "ERROR: flock() failed." >&2; exit 1; }

git pull

echo "Stopping containers"
sudo docker compose stop && sudo docker compose rm --force

#echo "Removing DB"
#sudo rm -fr /cache/nuget/db

echo "Removing NGINX cache"
sudo rm -fr /cache/nginx

[ -d "/cache/nuget/db" ] && die "DB Cache already exists"

[ -d /cache/nginx ] || sudo mkdir /cache/nginx
[ -d /cache/npm ] || sudo mkdir /cache/npm
[ -d /cache/nuget ] || sudo mkdir /cache/nuget


sudo chown -R 10001:65533 /cache/npm || die "Could not set npm permissions"

sudo docker compose pull || die "Could not pull images"
sudo docker compose up --no-start || die "Could not build containers"

sudo docker compose up -d --remove-orphans || die "Could not start containers"

