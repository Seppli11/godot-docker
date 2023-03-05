FROM debian:bullseye

MAINTAINER Sebastian Zumbrunn <sebastian.zumbrunn@pm.me>

ARG GODOT_VERSION=4.0-stable
LABEL org.opencontainers.image.source=https://github.com/Seppli11/godot-docker

RUN apt-get update \
    && apt-get install -y wget \
    && wget https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -O packages-microsoft-prod.deb\
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y unzip dotnet-sdk-7.0 \
    && wget \
"https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}/Godot_v${GODOT_VERSION}_mono_linux_x86_64.zip" \
"https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}/Godot_v${GODOT_VERSION}_mono_export_templates.tpz" \
    && unzip Godot_v*_mono_linux_x86_64.zip \
    && mv Godot_v*_linux_x86_64 /opt/godot \
    && mv /opt/godot/Godot_* /opt/godot/godot \
    && ln -s /opt/godot/godot /usr/local/bin/godot \
    && mkdir ~/.godot \
    && unzip -d ~/.godot Godot_v*_mono_export_templates.tpz \
    && rm -f *.zip *.tpz \
    && apt-get purge -y --auto-remove wget unzip \
    && rm -rf /var/lib/apt/lists/*
