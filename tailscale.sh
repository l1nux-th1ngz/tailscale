#!/bin/bash

# Identify the OS
OS="$(uname -s)"

if [[ "$OS" == "Linux" ]]; then
    # Identify the distribution
    DISTRO="$(lsb_release -is)"

    if [[ "$DISTRO" == "Arch" ]]; then
        sudo pacman -S --noconfirm tailscale
        sudo systemctl enable --now tailscaled
        sudo tailscale up
        tailscale ip -4
        # Disable Key Expiry

    elif [[ "$DISTRO" == "Debian" ]]; then
        curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
        curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
        sudo apt-get -y install tailscale
        sudo tailscale up
        tailscale ip -4

    elif [[ "$DISTRO" == "Fedora" ]]; then
        sudo dnf config-manager --add-repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo
        sudo dnf install -y tailscale
        sudo systemctl enable --now tailscaled
        sudo tailscale up
        tailscale ip -4

    else
        echo "Unsupported Linux distribution."
    fi

else
    echo "Unsupported operating system."
fi
