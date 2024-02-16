#!/bin/bash

download_discord() {
    echo "Downloading latest Discord version..."
    url="https://discord.com/api/download?platform=linux&format=tar.gz"
    output_file="discord.tar.gz"
    curl -L -o "$output_file" -A "Mozilla/5.0" "$url"
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
download_discord
install_discord
if folder_exists; then
    create_update_alias
    create_icon
fi
cleanup
