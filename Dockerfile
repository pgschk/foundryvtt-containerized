ARG NODE_HASH=1b2479dd35a99687d6638f5976fd235e26c5b37e8122f786fcd5fe231d63de5b
# node:22-alpine@sha256:sha256:1b2479dd35a99687d6638f5976fd235e26c5b37e8122f786fcd5fe231d63de5b (Alpine 3.22)

FROM node:22-alpine@sha256:${NODE_HASH}

WORKDIR /usr/src/app
ADD app/entrypoint.sh entrypoint.sh
RUN mkdir -p /usr/src/app/foundryvtt/ /data/foundryvtt/ && \
    chown -R 1000:0 /usr/src/app/ /data/foundryvtt/ && \
    chmod -R ugo+rwX /usr/src/app/ /data/foundryvtt/
COPY --chown=1000:0 --chmod=0777 foundry-instructions/ /usr/src/app/foundry-instructions
RUN apk add darkhttpd

USER 1000
EXPOSE 8080
ENTRYPOINT [ "/usr/src/app/entrypoint.sh" ]