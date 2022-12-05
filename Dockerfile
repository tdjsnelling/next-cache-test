FROM node:16 AS build
WORKDIR /app
COPY . .
RUN yarn install
RUN yarn build

FROM node:16
WORKDIR /app
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/public ./public
COPY --from=build /app/.next ./.next
COPY --from=build /app/next.config.js ./next.config.js
COPY --from=build /app/package.json ./package.json
COPY --from=build /app/production-server.js ./production-server.js
EXPOSE 3000
CMD ["yarn", "start"]
