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

## Egress firewall

`install` runs `egress/configure`, which loads one nftables table, `inet dpc_egress`, limiting what the host (`host_out`) and the containers (`docker_fwd`) may connect to: the package upstreams the proxies are configured with (api.nuget.org, the FunFair S3 feeds, registry.npmjs.org, builds.dotnet.microsoft.com), GitHub, ghcr.io and Docker Hub, the reverse proxies, DNS, NTP and central logging. CDN-fronted names are resolved every 10 minutes by `devpkg-egress-refresh.timer`; GitHub, Cloudflare and AWS S3 eu-west-1 use their published ranges, refreshed daily by the `Repo: Update egress ranges` workflow. `devpkg-firewall-sync.timer` re-applies the firewall when `egress/` changes (it does not pull: `update` does).

By default it only observes: anything not on the allow-list still flows and is logged. Review it with:

```bash
sudo journalctl -k --since -1d | grep -E 'devpkg-egress(-docker)?-unmatched'
```

then set `DEVPKG_FIREWALL_ENFORCE=true` in `.env` and run `sudo egress/configure` to drop it. Ingress to the published ports is still handled by `firewall`.

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
