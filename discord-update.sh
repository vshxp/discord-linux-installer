#!/bin/bash

function is_aria2c_installed() {
  if command -v aria2c >/dev/null 2>&1; then
    return 0  # Success (aria2c found)
  else
    return 1  # Failure (aria2c not found)
  fi
}

function install_aria2c() {
  echo "Installing aria2..."
  # Detect package manager
  if command -v apt >/dev/null 2>&1; then
    sudo apt install aria2
  elif command -v pamac >/dev/null 2>&1; then
    sudo pamac install aria2
  elif command -v yay >/dev/null 2>&1; then
    yay -Sy aria2
  elif command -v yum >/dev/null 2>&1; then
    sudo yum install aria2
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install aria2
  else
    echo "Unsupported package manager. Please install aria2 manually."
    return 1  # failure
  fi

  echo "aria2 installation complete."
  return 0  # success
}

download_discord() {
  echo "Downloading latest Discord version..."
  url="https://discord.com/api/download?platform=linux&format=tar.gz"
  output_file="discord.tar.gz"

  # Number of parallel download to get download speed
  paralell_download=8

  # Use aria2c with max threads and output filename
  aria2c -x "$paralell_download" -o "$output_file" "$url"

  echo "Download complete. The file is saved as: $output_file"
}

install_discord() {
    echo "Installing latest discord..."
    sudo rm -rf /opt/Discord
    sudo tar -xvzf discord.tar.gz -C /opt -k >/dev/null 2>&1
    sudo ln -sf /opt/Discord/Discord /usr/bin/discord
}

create_icon() {
  echo "Creating desktop icon" 
  cat <<EOF > ~/.local/share/applications/discord.desktop
[Desktop Entry]
Name=Discord
Comment=All-in-one voice and text chat for gamers
Exec=/usr/bin/discord
Icon=/opt/Discord/discord.png
Terminal=false
Type=Application
Categories=Network;InstantMessaging;Game;
EOF
}

cleanup() {
    echo "Removing unnecessary installation files..."
    sudo rm discord.tar.gz >/dev/null 2>&1
}

create_update_alias() {
    echo "Creating discord-update alias"
    sudo mkdir /opt/discord-updater
    sudo cp ./discord-update.sh /opt/discord-updater/discord-updater
    sudo ln -sf /opt/discord-updater/discord-updater /usr/bin/discord-updater
}

folder_exists() {
  local folder_path="/opt/discord-updater/"

  if [ -d "$folder_path" ]; then
    return 1  # Folder exists
  else
    return 0  # Folder does not exist
  fi
}

echo "Discord updater v2.1"
if is_aria2c_installed; then
  echo "aria2c is installed"
else
  echo "aria2c is not installed"
  install_aria2c
fi


download_discord
install_discord
if folder_exists; then
    create_update_alias
    create_icon
fi
cleanup
