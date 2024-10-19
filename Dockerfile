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
    bin/bash -c 'export TERM=xterm && { echo "aws"; echo "latest"; echo "y"; } | ./install.sh' && \ 
    bin/bash -c 'export TERM=xterm && { echo "csv"; echo "latest"; echo "y"; } | ./install.sh' && \
    bin/bash -c 'export TERM=xterm && { echo "jira"; echo "latest"; echo "y"; } | ./install.sh' && \
    bin/bash -c 'export TERM=xterm && { echo "awscfn"; echo "latest"; echo "y"; } | ./install.sh' 

RUN mkdir /var/lib/postgresql/.aws 
COPY aws/config /var/lib/postgresql/.aws/config 
COPY aws/credentials /var/lib/postgresql/.aws/credentials
RUN chown -Rf postgres:postgres /var/lib/postgresql/.aws