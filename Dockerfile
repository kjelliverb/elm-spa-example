FROM node:8.16.0 AS build-env
WORKDIR /app

RUN npm -g config set user root
RUN npm install -g elm

COPY src/ ./src/
COPY assets/ ./assets
COPY index.html .
COPY elm.json .

RUN elm make src/Main.elm --output elm.js --optimize

FROM nginx:alpine
WORKDIR /app
COPY default.conf /etc/nginx/conf.d/default.conf
COPY --from=build-env ./app/assets/ /usr/share/nginx/html/assets/
COPY --from=build-env ./app/index.html /usr/share/nginx/html/index.html
COPY --from=build-env ./app/elm.js /usr/share/nginx/html/elm.js