# Digest is kept up to date by Renovate. Alpine 3.24 ships Node.js 24.
FROM alpine:3.24@sha256:f59abe656b692d901e184be3445e084786602108599d2a51d229c0f5a48c71bf

# Node.js from Alpine's packages: no npm, yarn or corepack in the image.
# tini runs as PID 1 and passes signals on, so containers stop cleanly.
RUN apk upgrade --no-cache && \
    apk add --no-cache nodejs darkhttpd tini

WORKDIR /usr/src/app
COPY --chmod=0755 app/entrypoint.sh entrypoint.sh
COPY foundry-instructions/ /usr/src/app/foundry-instructions/
# Install and data dirs belong to uid 1000 and group 0, so the container also
# runs with an arbitrary uid in group 0 (e.g. OpenShift). The rest is read-only.
RUN chmod -R u=rwX,go=rX /usr/src/app/foundry-instructions/ && \
    mkdir -p /usr/src/app/foundryvtt/ /data/foundryvtt/ && \
    chown -R 1000:0 /usr/src/app/foundryvtt/ /data/foundryvtt/ && \
    chmod -R ug+rwX,o-rwx /usr/src/app/foundryvtt/ /data/foundryvtt/

USER 1000
EXPOSE 8080
ENTRYPOINT [ "/sbin/tini", "--", "/usr/src/app/entrypoint.sh" ]
