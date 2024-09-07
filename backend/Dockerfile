FROM node:current-bookworm-slim

RUN apt update -y && apt install -y openssl

COPY ./package.json .
COPY ./package-lock.json .
COPY ./tsconfig.json .
RUN npm install
COPY ./.env .

COPY ./prisma /prisma
COPY ./dist /dist

RUN npx prisma generate

ENV NODE_ENV=production
EXPOSE 7001

CMD ["npm","run","start"]