# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!--
Please ADD ALL Changes to the UNRELEASED SECTION and not a specific release
-->

## [Unreleased]
### Security
- Hardened containers in docker-compose.yml with read-only root filesystems, adding tmpfs mounts for the writable scratch paths each service needs
- Hardened containers in docker-compose.yml by dropping all Linux capabilities and setting no-new-privileges, except devpkg-nginx which needs its default capability set to start reliably
- Switched devpkg-nginx to the nginxinc/nginx-unprivileged base image and re-applied cap_drop: [ALL] / no-new-privileges, adding back CHOWN, SETGID and SETUID which it still needs at startup
- Pinned an explicit 1777 mode on devpkg-nginx's tmpfs mounts using inline colon-suffixed options, since some Docker/Podman versions default anonymous tmpfs to a non-writable root-owned mode and not every host's Compose parser supports the long-form tmpfs mount syntax
### Added
### Fixed
- Fixed OpenSSL 3.x PKCS12 passphrase compatibility by adding -legacy flag to openssl pkcs12 export and import commands in certs/generate; regenerated all TLS certificates with 100-year validity
- Nginx cache directory not being given correct ownership on install, causing permission denied errors when caching upstream responses
- Increased nginx proxy_connect/send/read timeouts to 99s on the NuGet/npm cache vhosts, fixing 504 Gateway Timeout errors when a cold-cache package fetch from the upstream source took longer than nginx's default 60s timeout
### Changed
- Moved sample nuget.config to client-config/nuget.config
- Disabled nginx proxy caching as upstream services handle their own caching
- update script no longer prunes the docker builder or system cache on buildagent-* hosts
### Deprecated
### Removed
### Deployment Changes
<!--
Releases that have at least been deployed to staging, BUT NOT necessarily released to live.  Changes should be moved from [Unreleased] into here as they are merged into the appropriate release branch
-->
## [0.0.0] - Project created