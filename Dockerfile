FROM debian:bullseye

MAINTAINER Sebastian Zumbrunn <sebastian.zumbrunn@pm.me>

ARG GODOT_VERSION=4.0-stable
LABEL org.opencontainers.image.source=https://github.com/Seppli11/godot-docker

RUN apt-get update \
    && apt-get install -y wget libxrender1 libfontconfig libxext6 libc6 libxml2 default-jre\
    && wget https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -O packages-microsoft-prod.deb\
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y unzip dotnet-sdk-7.0 fontconfig \
    && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]
RUN GODOT_LOCATION=$(if [[ $GODOT_VERSION == *"stable" ]]; then echo ${GODOT_VERSION%"-stable"}; else echo ${GODOT_VERSION/-/\/}; fi) \
    && wget "https://downloads.tuxfamily.org/godotengine/${GODOT_LOCATION}/mono/Godot_v${GODOT_VERSION}_mono_linux_x86_64.zip" \
    && unzip Godot_v*_mono_linux_x86_64.zip \
    && mv Godot_v*_linux_x86_64 /opt/godot \
    && mv /opt/godot/Godot_* /opt/godot/godot \
    && ln -s /opt/godot/godot /usr/local/bin/godot 

ENV DOTNET_CLI_TELEMETRY_OPTOUT=1

RUN useradd --system --create-home --home-dir /home/jenkins --shell /bin/bash --gid root --groups sudo --uid 1000 jenkins
USER jenkins
WORKDIR /home/jenkins

RUN GODOT_LOCATION=$(if [[ $GODOT_VERSION == *"stable" ]]; then echo ${GODOT_VERSION%"-stable"}; else echo ${GODOT_VERSION/-/\/}; fi) \
    && wget "https://downloads.tuxfamily.org/godotengine/${GODOT_LOCATION}/mono/Godot_v${GODOT_VERSION}_mono_export_templates.tpz" \
    && mkdir -p ~/.local/share/godot/export_templates \
    && unzip -d ~/.local/share/godot/export_templates Godot_v*_mono_export_templates.tpz \
    && ls -la ~/.local/share/godot/export_templates \
    && mv "/home/jenkins/.local/share/godot/export_templates/templates/" "/home/jenkins/.local/share/godot/export_templates/$(echo "${GODOT_VERSION}" | sed "s/-/./g").mono" \
    && rm -f *.zip *.tpz

SHELL ["/bin/sh", "-c"]
RUN dotnet tool install --global dotnet-reportgenerator-globaltool \
    && dotnet tool install --global dotnet-coverage \
    && dotnet tool install --global dotnet-sonarscanner

ENV PATH="${PATH}:/home/jenkins/.dotnet/tools"