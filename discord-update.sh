#!/bin/bash
echo "Downloading last Discord version..."

url="https://discord.com/api/download?platform=linux&format=tar.gz"
output_file="discord.tar.gz"

curl -L -o "$output_file" -A "Mozilla/5.0" "$url"

echo "Download complete. The file is saved as: $output_file"
echo "Installing latest discord..."
sudo rm -rf /opt/Discord
sudo tar -xvzf discord.tar.gz -C /opt >/dev/null 2>&1
sudo ln -sf /opt/Discord/Discord /usr/bin/discord

echo "Creating discord-update alias"
sudo cp ./discord-update.sh /opt/Discord/discord-update
sudo ln -sf /opt/Discord/discord-update /usr/bin/discord-update

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
echo ""