# Digest is kept up to date by Renovate
FROM node:24-alpine@sha256:116b800c3754b440ee0aa3ed2f20f5bf3d99a554bfd9adeea09ea8017f6e85f5

WORKDIR /usr/src/app
COPY app/entrypoint.sh entrypoint.sh
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