FROM node:10.12 as base
ENV PORT 5000
EXPOSE 5000

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY package.json package-lock.json ./
RUN npm install

#################################

FROM base AS dev
RUN npm install -g nodemon

#################################

FROM base AS prod

COPY . .
# RUN npm run dev:build:server
# RUN npm run dev:build:client
RUN npm run build

CMD ["npm", "start"]
# CMD ["npm", "run", "dev:server"]
