FROM golang:1.17-rc-buster AS builder

COPY . /go

ENV CGO_ENABLED=0

RUN cd src; go mod download;
RUN cd src; go build -a -tags netgo -ldflags '-w' -o /go/bin/app /go/src/main.go

# FROM golang:1.17-rc-buster
FROM scratch
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --chown=0:0 --from=builder /go/bin/app /bin/

EXPOSE 3000

CMD ["/bin/app"]