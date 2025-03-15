ARG NODE_HASH=8bda036ddd59ea51a23bc1a1035d3b5c614e72c01366d989f4120e8adca196d4
# node:20-alpine@sha256:8bda036ddd59ea51a23bc1a1035d3b5c614e72c01366d989f4120e8adca196d4 (Alpine 3.21)

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