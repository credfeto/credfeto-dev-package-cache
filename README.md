# credfeto-dev-package-cache

Development package cache

## Install

* Clone repo

```bash
./install
```

Starts the following services

* npm cache using [Verdaccio](https://verdaccio.org/) at <https://npm.local:5555>
* nuget proxy cache using [NuGet Proxy](https://github.com/credfeto/credfeto-nuget-proxy) at <https://api.nuget.local:5555/v3/index.json>
* dotnet install cache using [Cache Proxy](https://github.com/credfeto/credfeto-cache-proxy) at <https://builds.dotnet.local:5555>

## Configuration

Settings are read from a `.env` file in the repository root. Copy [.env.example](.env.example) to `.env` and edit it to override the defaults:

```bash
cp .env.example .env
```

If `update` has already created a `.env`, add the variables you want to override to it instead.

* `WATCHTOWER_SCHEDULE` - when Watchtower checks for updated images. A 6-field cron expression with seconds first. Default `0 6 * * * *` (6 minutes past every hour).

Watchtower removes the old images after updating a container.

## Setting up NPM

```bash
npm config set registry https://npm.local:5555
npm config set cafile $PWD/certs/npm.local.crt
```

also useful to adjust retries:

```bash
npm config set fetch-retries 3
npm config set fetch-retry-mintimeout 15000
npm config set fetch-retry-maxtimeout 90000
```

## Setting up NUGET

Sample [nuget.config](client-config/nuget.config) in repo needs copying to `.nuget/NuGet/NuGet.Config`
