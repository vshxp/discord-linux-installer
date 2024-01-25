#!/bin/bash
echo "Downloading..."

url="https://discord.com/api/download?platform=linux&format=tar.gz"
output_file="discord.tar.gz"

curl -L -o "$output_file" -A "Mozilla/5.0" "$url"

echo "Download complete. The file is saved as: $output_file"
echo "Installing..."
sudo tar -xvzf discord.tar.gz -C /opt
sudo ln -sf /opt/Discord/Discord /usr/bin/Discord

cat <<EOF > ~/.local/share/applications/discord.desktop
[Desktop Entry]
Name=Discord
Comment=All-in-one voice and text chat for gamers
Exec=/usr/bin/Discord
Icon=/opt/Discord/discord.png
Terminal=false
Type=Application
Categories=Network;InstantMessaging;Game;
EOF