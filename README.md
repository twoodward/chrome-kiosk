# XRDP + Openbox + Google Chrome (Auto-Close on Exit)

## Overview
This setup provides a lightweight **Ubuntu 24.04+** RDP environment using **Openbox** and **Google Chrome**.  
When a user connects via XRDP, Chrome opens in fullscreen. When Chrome closes, the session automatically ends.

---

## Features
- Minimal Openbox environment (no full desktop)
- Google Chrome runs fullscreen on login
- Session ends when Chrome is closed
- Compatible with domain logins (via XRDP)
- Lightweight and fast for web-based tools

---

## Requirements
- Ubuntu **24.04 LTS** or newer  
- Network access for package installation  
- Administrative privileges (`sudo`)

---

## Installation
Save the script below as `setup_xrdp_openbox_chrome.sh` and run as root:

```bash
sudo bash setup_xrdp_openbox_chrome.sh
```

---

## Script Details
The script performs the following steps:

1. **System Update**
   ```bash
   apt update -y && apt upgrade -y
   ```

2. **Install XRDP and Openbox**
   Installs required packages for a minimal window manager and RDP service:
   ```bash
   apt install -y xrdp openbox obconf tint2 xterm wget gpg
   ```

3. **Install Google Chrome (if not present)**
   Adds the official Google repository and installs Chrome if missing.

4. **Enable and Configure XRDP**
   - Enables XRDP to start at boot  
   - Replaces `/etc/xrdp/startwm.sh` with a script that:
     - Starts Openbox
     - Launches Chrome in fullscreen
     - Ends session when Chrome exits

   Example:
   ```bash
   google-chrome --start-maximized --no-first-run --disable-infobars
   ```

5. **Set Default Openbox Session**
   Ensures new users start in Openbox automatically:
   ```bash
   echo "openbox-session" > /etc/skel/.xsession
   ```

6. **Restart XRDP Service**
   ```bash
   systemctl restart xrdp
   ```

---

## Usage
1. Connect via **Remote Desktop (RDP)** to the host.
2. Log in with your system or domain credentials.
3. Openbox will launch and start Google Chrome automatically.
4. When Chrome closes, the XRDP session ends.

---

## Notes
- This configuration is intended for secure, kiosk-style access.
- To allow or block internet access, adjust your network firewall rules.
- Session cleanup is automatic on exit.

---

## File Reference
**Main XRDP startup script:**  
`/etc/xrdp/startwm.sh`

**Default user session file:**  
`/etc/skel/.xsession`

---

## Example Output
```
[*] Updating system...
[*] Installing XRDP and Openbox...
[*] Google Chrome already installed. Skipping installation.
[*] Configuring XRDP to start Openbox and close when Chrome exits...
[*] Setup complete.
Connect via RDP. Openbox launches with Google Chrome maximized.
Closing Chrome automatically ends the session.
```

---

## License
MIT License. Use at your own risk.
