FROM node:20-alpine@sha256:807e66e2bee193961c9642bb1157d77a61747bf76737ca786da45b10749dcb42 as builder

WORKDIR /usr/src/app
ADD foundry-instructions foundry-instructions
RUN cd foundry-instructions && \
    npm install . && \
    ./node_modules/.bin/ember build --environment production

FROM node:20-alpine@sha256:807e66e2bee193961c9642bb1157d77a61747bf76737ca786da45b10749dcb42
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