FROM node:11 as builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
ARG API_KEY
RUN npm run prod

FROM nginx:1.15.8-alpine
WORKDIR /app
COPY --from=builder /app/dist /app
COPY nginx.conf /etc/nginx/conf.d/default.conf
