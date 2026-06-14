# ============================================================================
# STAGE 1: BUILDER - Compile static binary using Alpine + MUSL
# ============================================================================
FROM rust:alpine AS builder

WORKDIR /app

# Install build dependencies for Alpine
# - pkgconfig: for finding libraries
# - openssl-dev & openssl-libs-static: SSL support (static)
# - fontconfig-dev: font handling
# - musl-dev: MUSL libc (static linking)
# - gcc & make: compilation tools
RUN apk add --no-cache \
    pkgconfig \
    openssl-dev \
    openssl-libs-static \
    fontconfig-dev \
    musl-dev \
    gcc \
    make

# Copy source code
COPY . .

# Build STATIC binary for MUSL target
# This creates a binary with NO external dependencies
RUN cargo build --release --target x86_64-unknown-linux-musl

# ============================================================================
# STAGE 2: RUNTIME - Minimal Alpine image
# ============================================================================
FROM alpine:latest

# Install runtime dependencies (minimal set)
# - ca-certificates: HTTPS/SSL support
# - openssl: runtime SSL
# - fontconfig: font rendering
RUN apk add --no-cache \
    ca-certificates \
    openssl \
    fontconfig

# Copy the STATIC binary from builder
# No glibc = no version conflicts!
COPY --from=builder /app/target/x86_64-unknown-linux-musl/release/giga_grabber /usr/local/bin/giga-grabber

# Make executable
RUN chmod +x /usr/local/bin/giga-grabber

# Set entrypoint
ENTRYPOINT ["giga-grabber"]
CMD ["--help"]
