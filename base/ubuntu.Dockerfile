FROM ubuntu:noble

USER root

SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    pipx \
    python3 \
    python3-pip \
    htop \
    git \
    jq \
    locales \
    sudo && \
    rm -rf /var/lib/apt/lists/*

# Generate the desired locale (en_US.UTF-8)
RUN locale-gen en_US.UTF-8

# Make typing unicode characters in the terminal work.
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Remove the `ubuntu` user and add a user `zenergy` so that you're not developing as the `root` user
RUN userdel -r ubuntu && \
    useradd zenergy \
    --create-home \
    --shell=/bin/bash \
    --uid=1000 \
    --user-group && \
    echo "zenergy:zenergy" | chpasswd && \
    echo "zenergy ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers.d/nopasswd

USER zenergy
RUN pipx ensurepath