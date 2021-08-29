ARG PORT=8080

FROM node:14-alpine

RUN apk --no-cache -U upgrade

RUN mkdir -p /home/node/app/dist && chown -R node:node /home/node/app

WORKDIR /home/node/app

ENV NODE_ENV production

COPY package*.json ./

USER node

RUN npm i --only=production

COPY --chown=node:node  . ./dist

EXPOSE ${PORT}

ENTRYPOINT ["node", "./dist/app.js"]
