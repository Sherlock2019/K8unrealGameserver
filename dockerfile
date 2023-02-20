FROM debian:10

# Install necessary packages
RUN apt-get update && \
    apt-get install -y curl wget gnupg2 && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-stretch-prod stretch main" > /etc/apt/sources.list.d/microsoft.list && \
    apt-get update && \
    apt-get install -y dotnet-sdk-2.2 && \
    wget https://github.com/EpicGames/UnrealEngine/releases/download/5.0.0-release/UnrealEngine-5.0.0-release.zip && \
    unzip UnrealEngine-5.0.0-release.zip && \
    cd UnrealEngine-5.0.0-release && \
    ./Setup.sh && \
    ./GenerateProjectFiles.sh && \
    make -j$(nproc) && \
    cd .. && \
    rm UnrealEngine-5.0.0-release.zip && \
    apt-get install -y netcat

# Copy game server files
COPY server /server

# Set working directory
WORKDIR /server

# Expose server port
EXPOSE 7777

# Set entrypoint to start game server
ENTRYPOINT ["./MyGameServer"]
