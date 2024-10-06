FROM --platform=linux/amd64 ubuntu:22.04

RUN apt update && \
    apt install -y wget && \
    wget https://dmej8g5cpdyqd.cloudfront.net/downloads/noip-duc_3.3.0.tar.gz && \
    tar xf noip-duc_3.3.0.tar.gz && \
    cd noip-duc_3.3.0/binaries && \
    apt install ./noip-duc_3.3.0_amd64.deb

# Create a script to check for required environment variables
RUN echo '#!/bin/sh\n\
if [ -z "$HOSTNAMES" ]; then echo "Error: HOSTNAMES is not set" && exit 1; fi\n\
if [ -z "$USERNAME" ]; then echo "Error: USERNAME is not set" && exit 1; fi\n\
if [ -z "$PASSWORD" ]; then echo "Error: PASSWORD is not set" && exit 1; fi\n\
exec noip-duc --hostnames "$HOSTNAMES" --username "$USERNAME" --password "$PASSWORD"' > /usr/local/bin/start-noip-duc && \
    chmod +x /usr/local/bin/start-noip-duc

# Set default environment variables (can be overridden at runtime)
ENV HOSTNAMES ""
ENV USERNAME ""
ENV PASSWORD ""

# Use the script as the entrypoint
ENTRYPOINT ["/usr/local/bin/start-noip-duc"]
