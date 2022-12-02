FROM node:16 AS build
WORKDIR /app
COPY . .
RUN yarn install
ARG NF_GIT_SHA
RUN yarn build

FROM node:16
WORKDIR /app
COPY --from=builder /sqtracker/node_modules ./node_modules
COPY --from=builder /sqtracker/public ./public
COPY --from=builder /sqtracker/.next ./.next
COPY --from=builder /sqtracker/next.config.js ./next.config.js
COPY --from=builder /sqtracker/package.json ./package.json
EXPOSE 3000
CMD ["node_modules/.bin/next", "start"]
