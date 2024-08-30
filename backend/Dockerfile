FROM node:current-bookworm-slim

COPY ./package.json .
COPY ./package-lock.json .
COPY ./tsconfig.json .
RUN npm ci --only=production

COPY ./.env .

COPY ./prisma /prisma
COPY ./src /src

ENV NODE_ENV=production
EXPOSE 7001

CMD ["npm","run","start"]