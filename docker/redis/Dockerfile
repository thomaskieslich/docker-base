ARG REDIS_VERSION

FROM redis:$REDIS_VERSION

COPY conf/ /opt/docker/etc/redis
CMD [ "redis-server", "/opt/docker/etc/redis/redis.conf" ]