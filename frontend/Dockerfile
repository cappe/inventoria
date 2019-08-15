# ==== development stage ====

FROM node:10-alpine as Builder
WORKDIR /usr/src
COPY package.json yarn.lock ./
RUN yarn install
COPY . .

# ==== build stage ====

FROM node:10-alpine as build-stage
ARG VUE_APP_API_URL
ARG VUE_APP_ENV
WORKDIR /usr/src
COPY package.json yarn.lock ./
RUN yarn install
COPY . .
RUN VUE_APP_API_URL=$VUE_APP_API_URL VUE_APP_ENV=$VUE_APP_ENV yarn build
