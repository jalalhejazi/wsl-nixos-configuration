#!/usr/bin/env bash
#
# pkg-install.sh — Universal package installer
# Detects available package manager and installs the given packages.
# sudo ./pkg-install.sh <package1> [package2 …]

set -e

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <package1> [package2 …]"
  exit 1
fi

PKGS=("$@")

install_with() {
  echo "==> Using $1 to install: ${PKGS[*]}"
  shift
  exec sudo "$@"
}

# detect and install
if   command -v apt-get      &>/dev/null; then
     sudo apt-get update
     install_with "apt-get" apt-get install -y "${PKGS[@]}"

elif command -v dnf          &>/dev/null; then
     install_with "dnf" dnf install -y "${PKGS[@]}"

elif command -v yum          &>/dev/null; then
     install_with "yum" yum install -y "${PKGS[@]}"

elif command -v zypper       &>/dev/null; then
     install_with "zypper" zypper install -y "${PKGS[@]}"

elif command -v pacman       &>/dev/null; then
     install_with "pacman" pacman -Sy --noconfirm "${PKGS[@]}"

elif command -v emerge       &>/dev/null; then
     install_with "emerge" emerge --ask=n "${PKGS[@]}"

elif command -v apk          &>/dev/null; then
     install_with "apk" apk add "${PKGS[@]}"

elif command -v xbps-install &>/dev/null; then
     install_with "xbps-install" xbps-install -Sy "${PKGS[@]}"

elif command -v pkg          &>/dev/null; then
     install_with "pkg" pkg install -y "${PKGS[@]}"

elif command -v snap         &>/dev/null; then
     install_with "snap" snap install "${PKGS[@]}"

elif command -v flatpak      &>/dev/null; then
     install_with "flatpak" flatpak install -y --noninteractive "${PKGS[@]}"

elif command -v nix-env      &>/dev/null; then
     install_with "nix-env" nix-env -i "${PKGS[@]}"

elif command -v guix         &>/dev/null; then
     install_with "guix" guix install "${PKGS[@]}"

elif command -v brew         &>/dev/null; then
     install_with "brew" brew install "${PKGS[@]}"

elif command -v conda        &>/dev/null; then
     install_with "conda" conda install -y "${PKGS[@]}"

elif command -v eopkg        &>/dev/null; then
     install_with "eopkg" eopkg install -y "${PKGS[@]}"

elif command -v slackpkg     &>/dev/null; then
     install_with "slackpkg" slackpkg install "${PKGS[@]}"

elif command -v spm          &>/dev/null; then
     install_with "spm" spm install "${PKGS[@]}"

else
  echo "Error: no supported package manager found on this system."
  exit 1
fi

