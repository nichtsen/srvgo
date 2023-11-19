FROM golang:1.18.1 AS builder

ENV GOPROXY https://goproxy.cn
ENV GOSUMDB sum.golang.google.cn

WORKDIR /src
COPY server/server.go ./
COPY go.mod ./

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -tags netgo,osusergo -ldflags '-w -extldflags "-static"' -o srvgo

# final container
FROM alpine:3.10 AS final

# modify timezone
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk add -U tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# ENV SRVGO_SERVER_PORT 31315
# EXPOSE $SRVGO_SERVER_PORT

WORKDIR /app
COPY --from=builder /src/srvgo .
ENTRYPOINT ["./srvgo"]
