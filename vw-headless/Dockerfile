FROM  ubuntu:latest

RUN set -eux ; \
    apt-get update ; \
    DEBIAN_FRONTEND='noninteractive' apt-get install -y --no-install-recommends -o APT::Immediate-Configure=false \
    apt-utils locales

RUN locale-gen "en_US.UTF-8"
ENV LC_ALL=en_US.UTF-8

RUN set -eux ; \
    echo 'root:root' | chpasswd ; \
    ln -fs /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime ; \
    apt-get update ; \
    DEBIAN_FRONTEND='noninteractive' apt-get install -y \
    tzdata sudo \
    lsb-release \
    gnupg2 apt-transport-https ca-certificates ; \
    echo "Set disable_coredump false" >> /etc/sudo.conf

#####################################################
# Create dev user
#####################################################

RUN set -eux ; \
    useradd --create-home --user-group --groups sudo dev ; \
    echo 'dev:dev' | chpasswd ; \
    echo "dev ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/dev ; \
    chmod 0440 /etc/sudoers.d/dev


#####################################################
# ZSH
#####################################################

RUN set -eux ; \
    apt-get update ; \
    DEBIAN_FRONTEND='noninteractive' apt-get install -y --no-install-recommends -o APT::Immediate-Configure=false zsh ; \
    echo 'export path=(/usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin)' >> /etc/zsh/zshenv ; \
    usermod -s /usr/bin/zsh root ; \
    usermod -s /usr/bin/zsh dev

SHELL ["/usr/bin/zsh", "-c"]
CMD ["/usr/bin/zsh"]


#####################################################
# File manipulation
#####################################################

RUN set -euxo pipefail ; \
    apt-get update ; \
    DEBIAN_FRONTEND='noninteractive' apt-get install -y --no-install-recommends -o APT::Immediate-Configure=false \
    file less \
    curl wget \
#    gawk sed \
#    jq \
    xz-utils unzip 

#####################################################
# cleanup
#####################################################

RUN apt-get clean ; \
    rm -rf /var/lib/apt/lists/*

#####################################################
# Default user and work dir
#####################################################

USER dev
RUN mkdir /home/dev/work
WORKDIR /home/dev/work
LABEL key="value"
COPY --chown=dev:dev home/dev /home/dev
