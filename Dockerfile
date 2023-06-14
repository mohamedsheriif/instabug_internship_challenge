FROM golang:1.20.5-alpine3.18 AS build_container

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download && go mod verify

COPY . .

RUN go build -v -o app .

FROM alpine:latest

MAINTAINER "Mohamed Sherif"

WORKDIR /app

COPY --from=build_container /app/app .

RUN groupadd --gid 1000 mohamed \
    && useradd --uid 1000 --gid mohamed --shell /bin/bash --create-home mohamed

RUN chown -R mohamed:mohamed /app

EXPOSE 9090

CMD [ "./app" ]