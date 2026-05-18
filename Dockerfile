FROM node:20.10.0

RUN mkdir -p /usr/src/sportsstore

COPY dist /usr/src/sportsstore/dist
COPY templates /usr/src/sportsstore/templates
COPY products.json /usr/src/sportsstore/
COPY server.config.json /usr/src/sportsstore/
COPY production.server.config.json /usr/src/sportsstore/
COPY package.json /usr/src/sportsstore/

WORKDIR /usr/src/sportsstore

RUN npm install --omit=dev
RUN npm install wait-for-it.sh@1.0.0

ENV NODE_ENV=production
ENV COOKIE_SECRET=${{sportsstore.COOKIE_SECRET}}
ENV GOOGLE_CLIENT_ID=${{sportsstore.GOOGLE_CLIENT_ID}}
ENV GOOGLE_CLIENT_SECRET=${{sportsstore.GOOGLE_CLIENT_SECRET}}

EXPOSE 5000

ENTRYPOINT npx wait-for-it postgres:5432 && node dist/server.js