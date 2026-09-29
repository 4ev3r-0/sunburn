#!/bin/bash
set -e

# 1. Clean up any leftover X11 locks from previous terminations
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1

# 2. Start Xvfb (Virtual Frame Buffer) on display :1
Xvfb :1 -screen 0 1280x1024x24 &
export DISPLAY=:1

# 3. Initialize the VNC password 
mkdir -p ~/.vnc
echo "$VNC_PASSWORD" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

# 4. Start the Window Manager in the background
xfce4-session &

# 5. Execute Xvnc directly to host the desktop
exec Xvnc :1 -auth ~/.Xauthority -geometry 1280x1024 -depth 24 -rfbauth ~/.vnc/passwd -rfbport 5901 -localhost no
