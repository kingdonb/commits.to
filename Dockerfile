FROM node:10.12
ENV PORT 5000
EXPOSE 5000

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
# RUN npm run dev:build:server
# RUN npm run dev:build:client
RUN npm run build

CMD ["npm", "start"]
# CMD ["npm", "run", "dev:server"]