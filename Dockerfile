# Use a Linux ARM64 base image
FROM arm64v8/ubuntu:latest AS arm64

# Print the architecture
RUN echo "Building for ARM64 architecture"

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

# Set the work directory
WORKDIR /workspace

# Argument to specify plugins (space-separated list)
ARG PLUGINS

# Create the binaries directory
RUN mkdir -p /workspace/binaries/

# Install specified plugins and copy their binaries
RUN if [ -z "$PLUGINS" ]; then \
	echo "Error: No plugins provided."; \
	exit 1; \
	else \
	for plugin in $PLUGINS; do \
	cargo install $plugin --target aarch64-unknown-linux-gnu; \
	cp /root/.cargo/bin/$plugin /workspace/binaries/ || exit 1; \
	done \
	fi

# Set the entry point
CMD ["bash"]

# Use a Linux x86_64 base image
FROM ubuntu:latest AS x86_64

# Print the architecture
RUN echo "Building for x86_64 architecture"

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

# Set the work directory
WORKDIR /workspace

# Argument to specify plugins (space-separated list)
ARG PLUGINS

# Create the binaries directory
RUN mkdir -p /workspace/binaries/

# Install specified plugins and copy their binaries
RUN if [ -z "$PLUGINS" ]; then \
	echo "Error: No plugins provided."; \
	exit 1; \
	else \
	for plugin in $PLUGINS; do \
	cargo install $plugin --target x86_64-unknown-linux-gnu; \
	cp /root/.cargo/bin/$plugin /workspace/binaries/ || exit 1; \
	done \
	fi

# Set the entry point
CMD ["bash"]

