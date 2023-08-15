# Use the official Ubuntu base image
FROM ubuntu:latest

MAINTAINER VladimirMeshcheriakov vladimir.meshcheriakov@epita.fr

# Set non-interactive mode during package installation
ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=host.docker.internal:0.0

# Update package lists and install necessary packages
RUN apt-get update && \
    apt-get install -y \
    xterm \
    git \
    iverilog \
    make \
    gtkwave \
    nodejs \
    npm \
    wget \
    libx11-xcb1 \
    libasound2 \
    libgtk-3-0 \
    libxss1 \
    libxtst6 \
    libcanberra-gtk-module \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    libgl1

# Install Visual Studio Code
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
    && install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/ \
    && sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' \
    && apt-get update && apt-get install -y code

# Create a working directory
WORKDIR /app

COPY src .

# Install required packages
RUN apt-get install -y \
    iverilog \
    make \
    gtkwave \
    nodejs \
    npm

# Set an entrypoint or CMD if needed
CMD ["bash"]