# TermLink

**TermLink** is a lightweight Python server that allows your Windows terminal (or any HTTP client) to interact with your Android phone over a local network using Termux.

Currently, it exposes limited phone features, with future expansions planned.

---

## Current Features

- **Battery status:** Query phone battery info using `/battery` endpoint.  
- **Vibration:** Trigger phone vibration with `/vibrate` endpoint.  

> ⚠ Notifications (`/notif`) and file transfer (`/send` & `/receive`) **do not work yet** due to Termux limitations on Android storage and notification access.

---

## How It Works

1. **Server on Phone:**  
   - The Flask server runs in Termux (`python server.py`) and listens on all network interfaces (`0.0.0.0`) at port 6969.  

2. **Client (Windows Terminal / PowerShell):**  
   - Sends HTTP requests to the phone’s LAN IP with the API key.  
   - Endpoints that are implemented run Termux commands (`termux-battery-status`, `termux-vibrate`) and return JSON or a simple status message.

3. **Network Requirement:**  
   - Phone and PC must be on the **same Wi-Fi network**.  

---

## Usage

  - Coming soon.

## Future Work
  - Notifications (/notif): Find a workaround to list notifications via Termux.

  - File transfer (/send & /receive): Enable uploading/downloading files safely using Termux storage or other accessible paths.

  -  Ringing Phone: Add a /ring endpoint to play a sound or notification for locating the phone.

  - Linux Terminal Support: Adapt client scripts for Linux to interact with the server over LAN.

  - Shift from teramux to any other platform.
