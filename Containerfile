FROM ghcr.io/nixos/nix:latest
LABEL com.github.containers.toolbox="true" \
    name="nixos-toolbox" \
    version="latest" \
    usage="This image is meant to be used with the toolbox or distrobox command" \
    summary="Base image for nixos toolbox container" \
    maintainer="Pratyay Mustafi<pratyaymustafi@outlook.com>"

RUN mkdir -p /etc/nix /etc/sudoers.d /usr/lib /media

COPY nix.conf /etc/nix/nix.conf
RUN nix-channel --update && \
    nix-env -iA nixpkgs.flatpak-builder && \
    nix-env -iA nixpkgs.coreutils && \
    nix-env -iA nixpkgs.bash && \
    nix-env -iA nixpkgs.zsh && \
    nix-env -iA nixpkgs.git && \
    nix-env -iA nixpkgs.flatpak && \
    nix-env -iA nixpkgs.flatpak-xdg-utils

RUN echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/sudoers
RUN echo 'NAME=NixOS Toolbox\nID=nixos\nPRETTY_NAME=NixOS\nHOME_URL="https://nixos.org/"\n' >> /usr/lib/os-release
RUN rm -rf /home/* && mkdir -p /media
RUN nix-collect-garbage -d
