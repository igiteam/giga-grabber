FROM rust:latest AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y \
    pkg-config \
    libssl-dev \
    libfontconfig1-dev \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY . .
RUN cargo build --release

# Use SAME debian version for runtime
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    ca-certificates \
    libssl3 \
    libfontconfig1 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/target/release/giga_grabber /usr/local/bin/giga-grabber

ENTRYPOINT ["giga-grabber"]
CMD ["--help"]
