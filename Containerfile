FROM ghcr.io/nixos/nix:latest
LABEL com.github.containers.toolbox="true" \
    name="nixos-toolbox" \
    version="latest" \
    usage="This image is meant to be used with the toolbox or distrobox command" \
    summary="Base image for nixos toolbox container" \
    maintainer="Pratyay Mustafi<pratyaymustafi@outlook.com>"

RUN mkdir -p /etc/nix /etc/sudoers.d /media

COPY nix.conf /etc/nix/nix.conf

RUN nix-channel --update && \
    nix-env -q && \
    (nix-env -e git-minimal git || true) && \
    nix-env -iA nixpkgs.nix nixpkgs.bash nixpkgs.coreutils nixpkgs.bashInteractive nixpkgs.zsh nixpkgs.git nixpkgs.flatpak nixpkgs.flatpak-builder nixpkgs.flatpak-xdg-utils nixpkgs.shadow nixpkgs.sudo

RUN mkdir -p /etc/sudoers.d && \
    grep -q '^wheel:' /etc/group || echo 'wheel:x:10:' >> /etc/group && \
    echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/sudoers && \
    chmod 440 /etc/sudoers.d/sudoers


RUN mkdir -p /usr/lib && touch /usr/lib/os-release

RUN printf 'NAME=NixOS Toolbox\nID=nixos\nPRETTY_NAME=NixOS\nHOME_URL="https://nixos.org/"\n' > /usr/lib/os-release

RUN rm -rf /home/*
RUN nix-collect-garbage -d
