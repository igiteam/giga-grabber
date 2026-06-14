# Stage 1: Build the binary
FROM rust:1.70-slim AS builder

WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y \
    pkg-config \
    libssl-dev \
    libfontconfig1-dev \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy source code
COPY . .

# Build the binary
RUN cargo build --release

# Stage 2: Create minimal runtime image
FROM debian:bookworm-slim

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    ca-certificates \
    libssl3 \
    libfontconfig1 \
    && rm -rf /var/lib/apt/lists/*

# Copy the binary from builder
COPY --from=builder /app/target/release/giga_grabber /usr/local/bin/giga-grabber

# Set entrypoint
ENTRYPOINT ["giga-grabber"]
CMD ["--help"]
