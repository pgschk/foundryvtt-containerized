ARG NODE_HASH=sha256:2a49bdf71e9fd965a58c1703fd9ddd205b34e5782b692a72dd1d248abb0beb43
# node:24-alpine (Alpine 3.24)

FROM node:22-alpine@${NODE_HASH}

WORKDIR /usr/src/app
ADD app/entrypoint.sh entrypoint.sh
RUN mkdir -p /usr/src/app/foundryvtt/ /data/foundryvtt/ && \
    chown -R 1000:0 /usr/src/app/ /data/foundryvtt/ && \
    chmod -R ugo+rwX /usr/src/app/ /data/foundryvtt/
COPY --chown=1000:0 --chmod=0777 foundry-instructions/ /usr/src/app/foundry-instructions
RUN apk upgrade --no-cache && \
    apk add --no-cache darkhttpd && \
    npm update -g && \
    npm upgrade -g

USER 1000
EXPOSE 8080
ENTRYPOINT [ "/usr/src/app/entrypoint.sh" ]