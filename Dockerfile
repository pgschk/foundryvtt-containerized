ARG NODE_HASH=sha256:8094c002d08262dba12645a3b4a15cd6cd627d30bc782f53229a2ec13ee22a00
# node:22-alpine@sha256:8094c002d08262dba12645a3b4a15cd6cd627d30bc782f53229a2ec13ee22a00 (Alpine 3.23)

FROM node:22-alpine@${NODE_HASH}

WORKDIR /usr/src/app
ADD app/entrypoint.sh entrypoint.sh
RUN mkdir -p /usr/src/app/foundryvtt/ /data/foundryvtt/ && \
    chown -R 1000:0 /usr/src/app/ /data/foundryvtt/ && \
    chmod -R ugo+rwX /usr/src/app/ /data/foundryvtt/
COPY --chown=1000:0 --chmod=0777 foundry-instructions/ /usr/src/app/foundry-instructions
RUN apk upgrade --no-cache && \
    apk add --no-cache darkhttpd && \
    npm update -g

USER 1000
EXPOSE 8080
ENTRYPOINT [ "/usr/src/app/entrypoint.sh" ]