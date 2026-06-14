FROM ubuntu:22.04 AS builder

RUN apt-get update && apt-get install -y \
    curl build-essential pkg-config libssl-dev libfontconfig1-dev ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app
COPY . .
RUN cargo build --release

FROM ubuntu:22.04
RUN apt-get update && apt-get install -y ca-certificates libssl3 libfontconfig1 && rm -rf /var/lib/apt/lists/*
COPY --from=builder /app/target/release/giga_grabber /usr/local/bin/giga-grabber
ENTRYPOINT ["giga-grabber"]
CMD ["--help"]
