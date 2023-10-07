FROM node:20-alpine@sha256:37750e51d61bef92165b2e29a77da4277ba0777258446b7a9c99511f119db096

WORKDIR /usr/src/app
ADD app/entrypoint.sh entrypoint.sh
RUN mkdir -p /usr/src/app/foundryvtt/ && \
    mkdir -p /data/foundryvtt/ && \
    chgrp -R 0 /usr/src/app && \
    chmod -R u+rwX /usr/src/app && \
    chmod -R o+rwX /usr/src/app && \
    chgrp -R 0 /data && \
    chmod -R u+rwX /data && \
    chmod -R o+rwX /data

USER 1000
EXPOSE 8080
ENTRYPOINT [ "/usr/src/app/entrypoint.sh" ]