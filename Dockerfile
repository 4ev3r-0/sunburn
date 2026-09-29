FROM ubuntu:24.04

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install X11, Xfce4 desktop, TigerVNC, and dependencies
RUN apt-get update && apt-get install -y \
    xvfb \
    xfce4 \
    xfce4-goodies \
    tigervnc-standalone-server \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Copy startup configurations
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose VNC default port (5901 for Display :1)
EXPOSE 5901

# Default environment configuration
ENV VNC_PASSWORD="githubcontainer"

ENTRYPOINT ["/start.sh"]
