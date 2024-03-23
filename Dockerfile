FROM node:18-alpine as build

WORKDIR /app

COPY package.json ./
COPY yarn.lock ./
RUN yarn install

COPY . .
RUN yarn build

FROM node:18-alpine

WORKDIR /app
COPY --from=build /app/package.json ./
COPY --from=build /app/yarn.lock ./
COPY --from=build /app/build ./build

RUN yarn install --production=true

EXPOSE 8080

ENTRYPOINT ["yarn", "start"]
