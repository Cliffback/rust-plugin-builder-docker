# rust-plugin-builder-docker
Docker image to build Rust plugins for either aarch64 or x86_64.

This was created to get Rust plugin binaries for use in prebuilt Docker containers depending on external binaries when run on non-linux systems, in my case macOS. I needed linux binaries, and could only find the source for the binaries I needed, so I created this Dockerfile to compile the binaries I needed.

## Usage
Run the following commands to build the image for your target architecture, and the cargo plugins you want.
```bash
docker build --target x86_64 --build-arg PLUGINS="plugin1 plugin2" -t cargoimage .
```
Run the container to get access to the binaries.
```bash
docker run --name cargocontainer cargoimage
```
Copy the binaries to your host machine.
```bash
docker cp cargocontainer:/workspace/binaries ~/.tmp/cargo
```
Remove the container and image.
```bash
docker rm cargocontainer && docker rmi cargoimage
```
