ARG BUILD_FROM
FROM $BUILD_FROM as os_build


RUN apk add --no-cache \
  nodejs \
  npm \
  yarn


FROM os_build as app_deps

WORKDIR /yolo/app

COPY ./package.json ./package.json

RUN yarn install --frozen-lockfile

FROM app_deps as app_build

COPY . .

RUN yarn build

FROM os_build as app

WORKDIR /yolo/app

COPY --from=app_build /yolo/app/src ./dist

CMD ["node", "dist/index.js"]

