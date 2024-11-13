FROM node:lts-bookworm AS dependencies
WORKDIR /
COPY ./site/package.json .
RUN npm install


FROM node:lts-alpine3.20 AS deploy
WORKDIR /
COPY --from=dependencies ./node_modules ./node_modules
COPY ./site .
EXPOSE 8080
CMD [ "npm", "start" ]
