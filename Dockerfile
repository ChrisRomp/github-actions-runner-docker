FROM ubuntu:18.04

ARG RUNNER_PLATFORM="linux"

# update the packages, add docker user
RUN apt-get update -y && apt-get upgrade -y && useradd -m docker

# install packages
RUN apt-get install -y \
    curl \
    jq \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3 \
    python3-venv \
    python3-dev \
    rsync

# create the runner directory
RUN mkdir /home/docker/actions-runner

# get scripts
COPY *.sh ./
RUN chmod +x *.sh

# download and extract the runner
RUN ./install.sh

# install runner dependencies
RUN chown -R docker ~docker \
    && /home/docker/actions-runner/bin/installdependencies.sh

# set subsequent commands to run as docker user
USER docker

# set the entrypoint to the start.sh script
ENTRYPOINT ["./start.sh"]
