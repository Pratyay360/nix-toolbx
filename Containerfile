FROM ghcr.io/nixos/nix:latest
LABEL com.github.containers.toolbox="true" \
    name="nix-toolbox" \
    version="latest" \
    usage="This image is meant to be used with the toolbox or distrobox command" \
    summary="Base image for nixos toolbox container" \
    maintainer="Pratyay Mustafi<pratyaymustafi@outlook.com>"

RUN mkdir -p /etc/nix /etc/sudoers.d /media

COPY nix.conf /etc/nix/nix.conf

COPY extra-packages /
RUN nix-channel --update && \
    grep -v '^nixpkgs#util-linux$' /extra-packages | xargs nix profile install --impure --priority 5 && \
    nix profile install --impure --priority 6 nixpkgs#util-linux

RUN rm /extra-packages

RUN echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/toolbox

RUN rm -rf /media

RUN mkdir -p /usr/lib && touch /usr/lib/os-release

RUN printf 'NAME=NixOS Toolbox\nID=nixos\nPRETTY_NAME=NixOS\nHOME_URL="https://nixos.org/"\n' > /usr/lib/os-release
