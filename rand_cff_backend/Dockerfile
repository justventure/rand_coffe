FROM node:alpine
ENV TZ=Europe/Omsk
RUN apk add --no-cache curl bash postgresql-client && \
    npm install -g pnpm
WORKDIR /app
RUN curl -o /usr/local/bin/wait-for-it https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && \
    chmod +x /usr/local/bin/wait-for-it

COPY package*.json ./
RUN pnpm install

COPY . .

RUN npx prisma generate

RUN pnpm run build

ENTRYPOINT ["sh", "-c", "/usr/local/bin/wait-for-it -h postgres -p 7432 -t 45 --strict -- npx prisma migrate deploy && npx prisma generate && pnpm run start:prod"]
