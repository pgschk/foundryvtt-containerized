ARG NODE_HASH=d18f4d9889b217d3fab280cc52fbe1d4caa0e1d2134c6bab901a8b7393dd5f53

FROM node:20-alpine@sha256:${NODE_HASH} as builder

WORKDIR /usr/src/app
ADD foundry-instructions foundry-instructions
RUN cd foundry-instructions && \
    npm install . && \
    ./node_modules/.bin/ember build --environment production && \
    chown -R 1000:0 /usr/src/app/foundry-instructions/dist


FROM node:20-alpine@sha256:${NODE_HASH}

WORKDIR /usr/src/app
ADD app/entrypoint.sh entrypoint.sh
COPY --from=builder /usr/src/app/foundry-instructions/dist /usr/src/app/foundry-instructions
RUN mkdir -p /usr/src/app/foundryvtt/ /data/foundryvtt/ && \
    chgrp -R 0 /usr/src/app/foundryvtt/ /data/foundryvtt/ && \
    chmod -R u+rwX /usr/src/app/foundryvtt/ /data/foundryvtt/ && \
    chmod -R o+rwX /usr/src/app/foundryvtt/ /data/foundryvtt/
RUN npm install http-server -g

USER 1000
EXPOSE 8080
ENTRYPOINT [ "/usr/src/app/entrypoint.sh" ]