ARG NODE_HASH=sha256:968df39aedcea65eeb078fb336ed7191baf48f972b4479711397108be0966920
# node:22-alpine (Alpine 3.23)

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