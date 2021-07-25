FROM node:12

ARG ENV
ARG WORKDIR
ARG APP_PATH

ENV NODE_ENV=${ENV}

WORKDIR ${WORKDIR}

#COPY ${APP_PATH} .

#RUN npm install --production

CMD [ "node", "server.js" ]
