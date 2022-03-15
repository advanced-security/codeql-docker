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
RUN chmod +x install.sh && ./install.sh --github-cli
# Add scripts to bin
ADD config/* /codeql
ADD bin/* /bin

# Create CodeQL user
RUN useradd -m codeql && chown -R codeql:codeql /codeql
USER codeql

WORKDIR /workspace

ENTRYPOINT [ "bash" ]
