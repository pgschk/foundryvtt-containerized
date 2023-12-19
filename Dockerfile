ARG NODE_HASH=d016f19a31ac259d78dc870b4c78132cf9e52e89339ff319bdd9999912818f4a

FROM node:20-alpine@sha256:${NODE_HASH} as builder

WORKDIR /usr/src/app
ADD foundry-instructions foundry-instructions
RUN cd foundry-instructions && \
    npm install . && \
    ./node_modules/.bin/ember build --environment production && \
    chown -R 1000:0 /usr/src/app/foundry-instructions/dist && \
    chmod -R g+w /usr/src/app/foundry-instructions/dist


FROM node:20-alpine@sha256:${NODE_HASH}

WORKDIR /usr/src/app
ADD app/entrypoint.sh entrypoint.sh
RUN mkdir -p /usr/src/app/foundryvtt/ /data/foundryvtt/ && \
    chown -R 1000:0 /usr/src/app/ /data/foundryvtt/ && \
    chmod -R ugo+rwX /usr/src/app/ /data/foundryvtt/
COPY --from=builder /usr/src/app/foundry-instructions/dist /usr/src/app/foundry-instructions
RUN npm install http-server -g

USER 1000
EXPOSE 8080
ENTRYPOINT [ "/usr/src/app/entrypoint.sh" ]