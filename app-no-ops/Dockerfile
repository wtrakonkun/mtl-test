FROM golang:1.20

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY *.go ./

RUN CGO_ENABLED=0 GOOS=linux go build -o /app-no-ops

EXPOSE 8080

CMD ["/app-no-ops"]

# docker build -t app-no-ops:1.0 .