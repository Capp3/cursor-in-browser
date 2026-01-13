FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm

# Set version, display and download link
ARG CURSOR_FULL_VERSION=2.3.35
ARG CURSOR_VERSION=2.3
ENV DISPLAY=:1
ENV CURSOR_DOWNLOAD_URL="https://api2.cursor.sh/updates/download/golden/linux-x64/cursor/${CURSOR_VERSION}/${CURSOR_VERSION}Cursor-${CURSOR_FULL_VERSION}-x86_64.AppImage"

# Update and install necessary packages
RUN echo "**** install packages ****" && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    fuse \
    python3.11-venv \
    libfuse2 \
    python3-xdg \
    libgtk-3-0 \
    libnotify4 \
    libatspi2.0-0 \
    libsecret-1-0 \
    libnss3 \
    desktop-file-utils \
    fonts-noto-color-emoji \
    git \
    ssh-askpass && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

# Download Cursor AppImage and manage permissions
RUN curl --location --output Cursor.AppImage $CURSOR_DOWNLOAD_URL && \
    chmod a+x Cursor.AppImage

# Environment variables
ENV CUSTOM_PORT="8080" \
    CUSTOM_HTTPS_PORT="8443" \
    CUSTOM_USER="" \
    PASSWORD="" \
    SUBFOLDER="" \
    TITLE="Cursor v${CURSOR_VERSION}" \
    FM_HOME="/cursor"

# Add local files and Cursor icon
COPY src/root/ /
COPY src/cursor_icon.png /cursor_icon.png

# Expose ports and volumes
EXPOSE 8080 8443
VOLUME ["/config","/cursor"]
