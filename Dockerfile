FROM golang:1.19.4-alpine3.17 as builder

RUN apk add --no-cache gcc git make musl-dev

COPY . /src
RUN make -C /src install PREFIX=/pkg GO111MODULE=on CGO_ENABLED=0 GO_BUILDFLAGS='-mod vendor'

################################################################################

FROM scratch as scratch
COPY --from=builder /pkg/ /usr/
ENTRYPOINT ["/usr/bin/ntp_exporter"]

FROM quay.io/sysdig/sysdig-mini-ubi:1.4.7 as ubi

COPY --from=builder /pkg/ /usr/
ENTRYPOINT ["/usr/bin/ntp_exporter"]
