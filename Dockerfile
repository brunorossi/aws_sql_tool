FROM postgres:15-bookworm

RUN apt update && \
apt install -y \
build-essential \
postgresql-server-dev-15 \
git \ 
pkg-config \
curl \
awscli

COPY install.sh . 
RUN chmod u+x install.sh && \
    bin/bash -c 'export TERM=xterm && { echo "aws"; echo "latest"; echo "y"; } | ./install.sh'     
