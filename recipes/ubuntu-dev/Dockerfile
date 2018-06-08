    # Development environment for che workspace
# Java, Gradle, make, thrift

FROM eclipse/ubuntu_jdk8

ENV GRADLE_VERSION=4.8
ENV GRADLE_HOME /home/user/gradle-$GRADLE_VERSION
ENV PATH $GRADLE_HOME/bin:$PATH

RUN wget -P /home/user/ --quiet https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip && \
    cd /home/user/ && unzip gradle-$GRADLE_VERSION-bin.zip && rm gradle-$GRADLE_VERSION-bin.zip

ENV DEBIAN_FRONTEND noninteractive

RUN sudo apt-get update && \
sudo apt-get install -y --no-install-recommends \
libboost-all-dev \
build-essential
