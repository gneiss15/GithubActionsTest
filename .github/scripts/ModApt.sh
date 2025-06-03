#!/bin/bash

#set -x
#set -v

sudo cp 99x-my /etc/apt/apt.conf.d/99x-my
#echo -e "Binary::apt::APT::Keep-Downloaded-Packages "true";\nAPT::Keep-Downloaded-Packages "true";\n" | sudo tee /etc/apt/apt.conf.d/99x-my

if [ ! -d "$APT_CACHE_DIR" ]; then
  mkdir -p "$APT_CACHE_DIR"
  sudo mv /var/cache/apt/archives/ "$APT_CACHE_DIR"
 else
  echo "$APT_CACHE_DIR exists"
  sudo rm -r /var/cache/apt/archives/
fi
sudo ln -s "$APT_CACHE_DIR/archives/" /var/cache/apt/archives

