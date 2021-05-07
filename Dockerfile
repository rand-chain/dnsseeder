FROM golang:1.16 AS builder
WORKDIR /dnsseeder/
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o dnsseeder .

FROM alpine:latest  
RUN apk --no-cache add ca-certificates bash
COPY --from=builder /dnsseeder/ /dnsseeder/
EXPOSE 53 8333
CMD ["/dnsseeder/dnsseeder", "-v", "-netfile", "/dnsseeder/configs/randchain.json"]  