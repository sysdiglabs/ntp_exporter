# renovate: datasource=docker depName=alpine versioning=docker
ARG ALPINE_VERSION=3.15
# renovate: datasource=docker depName=golang versioning=docker
ARG GOLANG_VERSION=1.17.10-alpine

FROM golang:${GOLANG_VERSION}${ALPINE_VERSION} as builder
RUN apk add --no-cache make gcc musl-dev

COPY . /src
RUN make -C /src install PREFIX=/pkg GO111MODULE=on CGO_ENABLED=0 GO_BUILDFLAGS='-mod vendor'

################################################################################

FROM scratch as scratch
COPY --from=builder /pkg/ /usr/
ENTRYPOINT ["/usr/bin/ntp_exporter"]

FROM quay.io/sysdig/sysdig-mini-ubi:1.2.12 as ubi

COPY --from=builder /pkg/ /usr/
ENTRYPOINT ["/usr/bin/ntp_exporter"]