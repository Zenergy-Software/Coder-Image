FROM ubuntu:noble

USER root

SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

# Install basic packages, programming tools, and networking utilities
RUN apt-get update && \
    apt-get install --yes --no-install-recommends --no-install-suggests \
    curl \
    bash \
    htop \
    jq \
    locales \
    man \
    pipx \
    python3 \
    python3-pip \
    sudo \
    systemd \
    systemd-sysv \
    unzip \
    vim \
    wget \
    ca-certificates \
    rsync \
    software-properties-common \
    build-essential \
    tree \
    nano \
    net-tools \
    iputils-ping \
    openssh-client \
    grep && \
# Install latest Git using their official PPA
    add-apt-repository ppa:git-core/ppa && \
    apt-get install --yes git \
    && rm -rf /var/lib/apt/lists/*

# Add the Docker GPG key and repository
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
RUN chmod a+r /etc/apt/keyrings/docker.asc

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

# Install Docker
RUN apt-get update && \
    apt-get install --yes --no-install-recommends --no-install-suggests \
    containerd.io \
    docker-ce \
    docker-ce-cli \
    docker-buildx-plugin \
    docker-compose-plugin \
    && rm -rf /var/lib/apt/lists/*

# Enables Docker starting with systemd
RUN systemctl enable docker

# Create a symlink for standalone docker-compose usage
RUN ln -s /usr/libexec/docker/cli-plugins/docker-compose /usr/bin/docker-compose

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
    --groups=docker \
    --uid=1000 \
    --user-group && \
    echo "zenergy:zenergy" | chpasswd && \
    echo "zenergy ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers.d/nopasswd

USER zenergy
RUN pipx ensurepath # adds user's bin directory to PATH