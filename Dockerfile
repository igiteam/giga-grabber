# ============================================================================
# FINAL WORKING DOCKERFILE - Use Ubuntu with musl-tools
# ============================================================================
FROM ubuntu:22.04 AS builder

WORKDIR /app

# Install system dependencies including MUSL toolchain
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    musl-tools \
    pkg-config \
    libssl-dev \
    libfontconfig1-dev \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Add MUSL target
RUN rustup target add x86_64-unknown-linux-musl

# Copy source
COPY . .

# Build static binary
RUN cargo build --release --target x86_64-unknown-linux-musl

# Runtime stage
FROM alpine:latest

RUN apk add --no-cache \
    ca-certificates \
    openssl \
    fontconfig

COPY --from=builder /app/target/x86_64-unknown-linux-musl/release/giga_grabber /usr/local/bin/giga-grabber

RUN chmod +x /usr/local/bin/giga-grabber

ENTRYPOINT ["giga-grabber"]
CMD ["--help"]
