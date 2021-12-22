FROM node:16-alpine as build

WORKDIR /app

COPY package*.json ./
COPY yarn.lock ./
RUN yarn install

COPY . .
RUN yarn build

FROM node:16-alpine

WORKDIR /app
COPY --from=build /app/package.json ./
COPY --from=build /app/build ./build

RUN yarn install --production=true

EXPOSE 8080

ENTRYPOINT ["node", "-r", "source-map-support/register", "build/main.js"]
