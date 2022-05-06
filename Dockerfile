ARG PHP_VERSION=8.0
ARG FROM_PHP_VERSION="php:${PHP_VERSION}-fpm-bullseye"
FROM $FROM_PHP_VERSION

# Set Environment Variables
ENV DEBIAN_FRONTEND noninteractive

ARG CCM_VERSION=1.0.0
ARG CCM_DOWNLOAD_URL="https://github.com/leads-su/consul-config-manager/releases/download/${CCM_VERSION}/ccm_${CCM_VERSION}_linux_amd64.zip"


# Update sources list, install latest version of libraries and then install and configure the "zip" package & extension
RUN set -xe; \
    apt clean && \
    apt update -yqq && \
    apt install -yqq ca-certificates software-properties-common dirmngr apt-transport-https && \
    apt update -yqq && \
    pecl channel-update pecl.php.net && \
    apt install -yqq \
        apt-utils libzip-dev zip unzip dos2unix && \
        docker-php-ext-configure zip && \
        docker-php-ext-install zip && \
        php -m | grep -q 'zip'

# Install CCM

RUN curl -L -o /tmp/ccm.zip "${CCM_DOWNLOAD_URL}" && \
    mkdir -p /tmp/ccm && \
    unzip /tmp/ccm.zip -d /tmp/ccm && \
    mv /tmp/ccm/ccm /usr/bin/ccm && \
    chmod +x /usr/bin/ccm

RUN groupadd ccm && \
    useradd -rm -d /home/scripts -s /bin/bash -g root -G ccm -u 1001 ccm && \
    mkdir /var/log/ccm && chown -R ccm:ccm /var/log/ccm

COPY root/ /

RUN chown -R ccm:ccm /etc/ccm.d && \
    chown -R ccm:ccm /home/scripts && \
    chown ccm:ccm /entrypoint.sh && \
    chmod +x /entrypoint.sh

USER ccm

EXPOSE 32175
CMD []
ENTRYPOINT [ "bash", "/entrypoint.sh" ]