ARG NODE_HASH=9632533eda8061fc1e9960cfb3f8762781c07a00ee7317f5dc0e13c05e15166f
# node:22-alpine@sha256:s9632533eda8061fc1e9960cfb3f8762781c07a00ee7317f5dc0e13c05e15166f (Alpine 3.23)

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