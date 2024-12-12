# Stage 1: Build js files from ts
FROM node:22-alpine AS builder

WORKDIR /app

COPY ./nest-auth-ms/package*.json ./

RUN npm install

COPY ./nest-auth-ms .

RUN npm run build

RUN npm prune --production

# Stage 2: Build image for production
FROM node:22-alpine AS runner

ARG port=3000

ENV PORT=${port}

WORKDIR /app

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules

EXPOSE ${port}

CMD ["node", "dist/main.js"]
