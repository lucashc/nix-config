#!/bin/sh

echo "Linking home-manager config..."
ln -sf ~/nix-config/home-config/* ~/.config/nixpkgs/

echo "About to copy global config"
read -r -p "Continue? (type y to continue) " continue

if [[ $continue == 'y' ]]; then
  sudo cp system-config/* /etc/nixos/
fi

