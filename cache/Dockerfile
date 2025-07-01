
FROM alpine:latest

WORKDIR /usr/src/app

COPY populate .
COPY healthcheck .
copy nuget.config .

SHELL ["/bin/ash", "-o", "pipefail", "-c"]

RUN apk add --no-cache \
        bash \
        ca-certificates \
        curl  \
        doas \
        git \
        gnupg \
        icu-libs \
        krb5-libs \
        libgcc \
        libintl \
        libssl3 \
        libstdc++ \
        openssh \
        sed \
        zlib

# Add Updater group
RUN \
    # Add updater user \
    mkdir /local && \
    addgroup -S "updater" && \
    adduser -S -D "updater" -G "updater" -h /local && \
    chmod -R 700 /local && \
    echo 'permit nopass :updater as root' > /etc/doas.d/doas.conf && \
    ls -la /usr/src/app/ && \
    mkdir -p /local/.nuget/NuGet && \
    cp /usr/src/app/nuget.config /local/.nuget/NuGet/NuGet.Config && \
    chown -R updater:updater /local && \
    mkdir -p /root/.nuget/NuGet && \
    cp /usr/src/app/nuget.config /root/.nuget/NuGet/NuGet.Config

USER updater

RUN mkdir -p /local/dotnet

ENTRYPOINT [ "/usr/src/app/populate" ]

ENV DOTNET_CHANNELS="$DOTNET_CHANNELS"
ENV REPOS_LIST="$REPOS_LIST"
ENV PACKAGES="$PACKAGES"
ENV TEMPLATE="$TEMPLATE"
ENV RELEASE="$$RELEASE"

#HEALTHCHECK --interval=5s --timeout=2s --retries=3 --start-period=60s CMD [ "/usr/src/app/healthcheck" ]
