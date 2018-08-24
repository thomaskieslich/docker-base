ARG APP_IMAGE
ARG APP_TAG

FROM $APP_IMAGE:$APP_TAG

COPY --chown=application:application ./app/ /app/

WORKDIR /app/