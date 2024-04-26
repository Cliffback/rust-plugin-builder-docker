docker build --build-arg PLUGINS="mdbook-toc" -t myimage .

docker run --name mycontainer myimage

docker cp mycontainer:/workspace/binaries ~/.tmp/cargo

docker rm mycontainer
docker rmi myimage
