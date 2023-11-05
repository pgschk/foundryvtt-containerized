FROM node:20-alpine@sha256:807e66e2bee193961c9642bb1157d77a61747bf76737ca786da45b10749dcb42

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