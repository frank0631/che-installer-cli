# Gradle and Make Development environment for che workspace
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

RUN sudo apt-get update -y && \
    sudo apt-get install --no-install-recommends -y python3 python3-dev python-pip git python3-pip && \
    sudo pip3 install -U pip && \
    sudo pip3 install virtualenv
RUN wget -qO- "https://storage.googleapis.com/appengine-sdks/featured/google_appengine_1.9.40.zip" -O /tmp/gae-sdk.zip && \
    unzip -q /tmp/gae-sdk.zip -d /home/user && \
    rm /tmp/gae-sdk.zip

RUN sudo apt-get update && \
    sudo apt-get -y install libkrb5-dev gcc make ruby-full rubygems debian-keyring && \
    sudo gem install --no-rdoc --no-ri sass -v 3.4.22 && \
    sudo gem install --no-rdoc --no-ri compass && \
    sudo apt-get clean && \
    sudo apt-get -y autoremove && \
    sudo apt-get -y clean && \
    sudo rm -rf /var/lib/apt/lists/*

RUN wget -qO- https://deb.nodesource.com/setup_8.x | sudo -E bash -
RUN sudo apt update && sudo apt -y install nodejs

EXPOSE 1337 3000 4200 5000 9000 8003
RUN sudo npm install --unsafe-perm -g yarn gulp bower grunt grunt-cli yeoman-generator yo generator-angular generator-karma generator-webapp typescript typescript-language-server

