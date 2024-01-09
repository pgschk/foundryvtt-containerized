ARG NODE_HASH=e96618520c7db4c3e082648678ab72a49b73367b9a1e7884cf75ac30a198e454
# node:20-alpine@sha256:e96618520c7db4c3e082648678ab72a49b73367b9a1e7884cf75ac30a198e454 (Alpine 3.19.0)

FROM node:20-alpine@sha256:${NODE_HASH} AS builder

WORKDIR /usr/src/app
ADD foundry-instructions foundry-instructions
RUN cd foundry-instructions && \
    npm install . && \
    ./node_modules/.bin/ember build --environment production && \
    chown -R 1000:0 /usr/src/app/foundry-instructions/dist && \
    chmod -R g+w,o+w /usr/src/app/foundry-instructions/dist


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