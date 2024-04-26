# Rust Plugin Builder
Docker image to build Rust plugins for either aarch64 or x86_64.

This was created to get Rust plugin binaries for use in Docker containers when built on non-linux systems, in my case macOS. I needed linux binaries, and could only find the source/

## Usage
Run the following commands to build the image for your target architecture, and the cargo plugins you want.
```bash
docker build --target x86_64 --build-arg PLUGINS="plugin1 plugin2" -t cargoimage .
```

```bash
docker run --name cargocontainer cargoimage
```

```bash
docker cp cargocontainer:/workspace/binaries ~/.tmp/cargo
```
```bash
docker rm cargocontainer && docker rmi cargoimage
```
