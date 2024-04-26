# Use a Linux ARM64 base image
FROM arm64v8/ubuntu:latest

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
	build-essential \
	cmake \
	pkg-config \
	libssl-dev \
	zlib1g-dev \
	libclang-dev \
	clang \
	curl \
	&& rm -rf /var/lib/apt/lists/*

# Install Rust using apt-get
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain none
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Rust toolchain
RUN rustup toolchain install stable
RUN rustup default stable

# Install mdbook and its plugins
RUN cargo install mdbook-external-links --target aarch64-unknown-linux-gnu
RUN cargo install mdbook-pandoc --target aarch64-unknown-linux-gnu
RUN cargo install mdbook-toc --target aarch64-unknown-linux-gnu

# Expose the binaries to the system
RUN ln -s /root/.cargo/bin/mdbook-external-links /usr/local/bin/mdbook-external-links
RUN ln -s /root/.cargo/bin/pandoc-preprocess /usr/local/bin/pandoc-preprocess
RUN ln -s /root/.cargo/bin/mdbook-toc /usr/local/bin/mdbook-toc

# Copy binaries to /workspace/binaries/
RUN mkdir -p /workspace/binaries/
RUN cp /root/.cargo/bin/mdbook-external-links /workspace/binaries/
RUN cp /root/.cargo/bin/mdbook-pandoc /workspace/binaries/
RUN cp /root/.cargo/bin/mdbook-toc /workspace/binaries/

# Set the work directory
WORKDIR /workspace

# Set the entry point
CMD ["bash"]

