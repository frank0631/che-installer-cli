# Development environment for che workspace
# Java, Gradle, make, thrift

FROM eclipse/ubuntu_gradle

USER user
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
sudo apt-get install -y --no-install-recommends \
build-essential