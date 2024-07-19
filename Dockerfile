FROM golang:alpine AS builer
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -v -o ./server ./cmd/server/
CMD ./server

FROM alpine
WORKDIR /app
COPY ./assets ./assets
COPY .env .env
COPY --from=builer /app/server ./server
CMD ./server