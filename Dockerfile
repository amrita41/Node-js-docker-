FROM node:12-slim

ARG NODE_ENV=production
ENV NODE_ENV $NODE_ENV

ARG PORT=3000
ENV PORT $PORT
EXPOSE $PORT 9229 9230

RUN npm i npm@latest -g


RUN mkdir /opt/node_app && chown node:node /opt/node_app
WORKDIR /opt/node_app

USER node
COPY package.json package-lock.json* ./
ADD ./secrets/masterlife-app-firebase-adminsdk-wip10-2c58a10563.json /usr/local/bin/secrets
COPY ./secrets/masterlife-app-firebase-adminsdk-wip10-2c58a10563.json /usr/local/bin/secrets
RUN npm install --no-optional && npm cache clean --force
ENV PATH /opt/node_app/node_modules/.bin:$PATH


HEALTHCHECK --interval=30s CMD node healthcheck.js


WORKDIR /opt/node_app/app
COPY . .

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]


CMD [ "node", "./bin/www" ]
