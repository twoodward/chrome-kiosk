#!/bin/bash
# XRDP + Openbox + Google Chrome (auto-closes session on exit)
# Compatible with Ubuntu 24.04+

set -e

echo "[*] Updating system..."
apt update -y
apt upgrade -y

echo "[*] Installing XRDP and Openbox..."
apt install -y xrdp openbox obconf tint2 xterm wget gpg

# Check if Google Chrome is already installed
if command -v google-chrome >/dev/null 2>&1; then
    echo "[*] Google Chrome already installed. Skipping installation."
else
    echo "[*] Adding Google Chrome repository and installing..."
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
      > /etc/apt/sources.list.d/google-chrome.list
    apt update -y
    apt install -y google-chrome-stable
fi

echo "[*] Enabling XRDP service..."
systemctl enable xrdp
systemctl restart xrdp

echo "[*] Configuring XRDP to start Openbox and close when Chrome exits..."
cat << 'EOF' > /etc/xrdp/startwm.sh
#!/bin/bash
# XRDP start script for Openbox + Google Chrome (ends session when Chrome closes)

unset DBUS_SESSION_BUS_ADDRESS
unset XDG_RUNTIME_DIR

# Start Openbox session in background
openbox-session &

# Allow Openbox to initialize
sleep 2

# Launch Google Chrome in foreground (maximized)
google-chrome --start-maximized --no-first-run --disable-infobars

# When Chrome exits, XRDP session closes
exit 0
EOF

chmod +x /etc/xrdp/startwm.sh

echo "[*] Setting default Openbox session for new users..."
echo "openbox-session" > /etc/skel/.xsession

echo "[*] Restarting XRDP..."
systemctl restart xrdp

echo "[*] Setup complete."
echo "Connect via RDP. Openbox launches with Google Chrome maximized."
echo "Closing Chrome automatically ends the session."
