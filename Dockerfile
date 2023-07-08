FROM node:20-alpine
WORKDIR /usr/src/app
ADD app/entrypoint.sh entrypoint.sh
ENTRYPOINT [ "/usr/src/app/entrypoint.sh" ]