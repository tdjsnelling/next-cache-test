FROM node:16 AS build
WORKDIR /app
COPY . .
RUN yarn install
ARG NF_GIT_SHA
RUN yarn build

FROM node:16
WORKDIR /app
COPY --from=build /sqtracker/node_modules ./node_modules
COPY --from=build /sqtracker/public ./public
COPY --from=build /sqtracker/.next ./.next
COPY --from=build /sqtracker/next.config.js ./next.config.js
COPY --from=build /sqtracker/package.json ./package.json
EXPOSE 3000
CMD ["node_modules/.bin/next", "start"]
