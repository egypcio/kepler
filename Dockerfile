# Build the binary
FROM golang:1.23 AS builder

ARG VERSION
ARG GIT_COMMIT
ARG GIT_BRANCH

WORKDIR /workspace

COPY . .

RUN make build \
  PRODUCTION=1 \
  VERSION=${VERSION} \
  GIT_COMMIT=${GIT_COMMIT} \
  GIT_BRANCH=${GIT_BRANCH}
######################################################################

# Use built binary in a container
FROM registry.access.redhat.com/ubi9:latest

RUN mkdir -p /etc/kepler
COPY --from=builder /workspace/bin/kepler-release /usr/bin/kepler
COPY --from=builder /workspace/hack/config.yaml /etc/kepler/.

ENTRYPOINT ["/usr/bin/kepler --config.file=/etc/kepler/config.yaml"]
