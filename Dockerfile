# Start by building the application.
FROM golang:1.19-alpine as build

WORKDIR /go/src/app
COPY . .

RUN go mod download
RUN go build -o /go/bin/app.bin cmd/main.go


# Final stage
FROM scratch
WORKDIR /
COPY --from=build /go/src/app .
RUN adduser -D -s /bin/sh simpleuser \
    && mkdir /home/simpleuser \
    && chown simpleuser:simpleuser /home/simpleuser
RUN chown simpleuser:simpleuser /app
USER simpleuser

ENTRYPOINT ["/app"]
VOLUME ["/upload"]