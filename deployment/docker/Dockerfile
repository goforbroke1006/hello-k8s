FROM debian:stretch-slim

LABEL maintainer="Sergey Cherkesov go.for.broke1006@gmail.com"

ARG SERVICE_NAME
ARG BINARY_FILE_LOCATION

ENV SERVICE_NAME=${SERVICE_NAME}

RUN echo "$BINARY_FILE_LOCATION -> /usr/local/bin/$SERVICE_NAME"
COPY $BINARY_FILE_LOCATION /usr/local/bin/$SERVICE_NAME

ENTRYPOINT /usr/local/bin/${SERVICE_NAME}
