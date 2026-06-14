# ============================================================================
# STAGE 1: BUILDER - Compile static binary using Alpine + MUSL
# ============================================================================
FROM rust:alpine AS builder

WORKDIR /app

# Install build dependencies including MUSL C compiler
RUN apk add --no-cache \
    pkgconfig \
    openssl-dev \
    openssl-libs-static \
    fontconfig-dev \
    musl-dev \
    musl-tools \
    gcc \
    g++ \
    make \
    file

# Add the MUSL target for static compilation
RUN rustup target add x86_64-unknown-linux-musl

# Set MUSL as the C compiler
ENV CC_x86_64_unknown_linux_musl=musl-gcc

# Copy source code
COPY . .

# Build STATIC binary for MUSL target
RUN cargo build --release --target x86_64-unknown-linux-musl

# ============================================================================
# STAGE 2: RUNTIME - Minimal Alpine image
# ============================================================================
FROM alpine:latest

# Install runtime dependencies
RUN apk add --no-cache \
    ca-certificates \
    openssl \
    fontconfig

# Copy the STATIC binary
COPY --from=builder /app/target/x86_64-unknown-linux-musl/release/giga_grabber /usr/local/bin/giga-grabber

# Make executable
RUN chmod +x /usr/local/bin/giga-grabber

# Set entrypoint
ENTRYPOINT ["giga-grabber"]
CMD ["--help"]
