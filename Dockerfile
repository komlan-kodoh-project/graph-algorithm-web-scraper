FROM alpine:3.18 AS build-environment

# Install rust
RUN apk add --no-cache rust cargo

FROM build-environment AS build-container

# Import source code
WORKDIR /build-artefact
COPY app .

# Build project in release mode
RUN ["cargo", "build", "--release"]

# Copy release file to output directory
RUN mv ./target/release ./output
RUN ls

FROM alpine:3.18

WORKDIR /app

# Import build result from previous layer
COPY --from=build-container /build-artefact/output /app

RUN ls

ENTRYPOINT ["/app/graph-algorithm-web-scraper"]