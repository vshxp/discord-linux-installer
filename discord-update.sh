#!/bin/bash

check_discord_update() {
    if command -v "discord-update" &> /dev/null; then
        return 0  # Command exists
    else
        return 1  # Command does not exist
    fi
}

download_discord() {
    echo "Downloading latest Discord version..."
    url="https://discord.com/api/download?platform=linux&format=tar.gz"
    output_file="discord.tar.gz"
    curl -L -o "$output_file" -A "Mozilla/5.0" "$url"
    echo "Download complete. The file is saved as: $output_file"
}

install_discord() {
    echo "Installing latest discord..."
    # sudo rm -rf /opt/discord
    # sudo tar -xvzf discord.tar.gz -C /opt -k >/dev/null 2>&1
    sudo tar -xvzf discord.tar.gz --strip-components=1 -C /opt/discord -k >/dev/null 2>&1
    sudo ln -sf /opt/discord/Discord /usr/bin/discord
}

create_icon() {
    echo "Creating desktop icon" 
    cat <<EOF > ~/.local/share/applications/discord.desktop
[Desktop Entry]
Name=Discord
Comment=All-in-one voice and text chat for gamers
Exec=/usr/bin/discord
Icon=/opt/discord/discord.png
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
    sudo cp ./discord-update.sh /opt/discord/discord-update
    sudo ln -sf /opt/discord/discord-update /usr/bin/discord-update
}

echo "Discord update v2"
download_discord
install_discord
if check_discord_update; then
    create_update_alias
    create_icon
fi
cleanup
