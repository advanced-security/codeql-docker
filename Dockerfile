FROM ubuntu:latest

# Updates, Install, and clean up
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install curl git -y && \
    apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

# Might need other tools / packages installed for certain languages

WORKDIR /codeql

# Run install script
ADD install.sh .
RUN chmod +x install.sh && ./install.sh

RUN useradd -m codeql && chown -R codeql:codeql /codeql

# Create CodeQL user
USER codeql
WORKDIR /workspace

# [optional] Add aliases
ADD aliases.sh /home/codeql/.bash_aliases

ENTRYPOINT [ "bash" ]
