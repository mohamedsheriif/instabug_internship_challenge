FROM golang:1.20.5-alpine3.18 AS build_container

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download && go mod verify

COPY . .

RUN go build -v -o app .

FROM alpine:latest 

WORKDIR /app

COPY --from=build_container /app/app .

EXPOSE 9090

CMD [ "./app" ]