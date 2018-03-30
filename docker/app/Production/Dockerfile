ARG SERVER_VERSION
ARG PHP_VERSION


FROM webdevops/php-$SERVER_VERSION:$PHP_VERSION

#ENV PROVISION_CONTEXT "production"

# Deploy scripts/configurations
COPY conf/ /opt/docker/etc/

RUN ln -sf /opt/docker/etc/cron/crontab /etc/cron.d/docker-boilerplate \
    && chmod 0644 /opt/docker/etc/cron/crontab \
    && echo >> /opt/docker/etc/cron/crontab

#set passwords
RUN echo "application:dev" | chpasswd \
    && echo "root:dev" | chpasswd

# Configure volume/workdir
WORKDIR /app/