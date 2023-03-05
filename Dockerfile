FROM alpine:3.17.2

MAINTAINER Sebastian Zumbrunn <sebastian.zumbrunn@pm.me>

ARG GODOT_VERSION=4.0-stable

RUN apk add dotnet7-sdk \
    && wget \
"https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}/Godot_v${GODOT_VERSION}_mono_linux_x86_64.zip" \
"https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}/Godot_v${GODOT_VERSION}_mono_export_templates.tpz" \
    && unzip Godot_v*_mono_linux_x86_64.zip \
    && mv Godot_v*_linux_x86_64 /bin/godot \
    && mkdir ~/.godot \
    && unzip -d ~/.godot Godot_v*_mono_export_templates.tpz \
    && rm -f *.zip *.tpz \
