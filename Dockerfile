FROM alpine:latest

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk
ENV ANDROID_HOME=/usr/bin/android

ENV PATH=$PATH:/usr/bin/android/cmdline-tools/bin
ENV DOWNLOADS_PATH=/tmp/downloads

# Install  dependencies
RUN apk update
RUN apk add --virtual build-dependencies build-base
RUN apk add curl zip openjdk11 ruby-dev git openssh-client

# Setup downloads folder for dependencies.
RUN mkdir $DOWNLOADS_PATH

# Download, verify and extract android command line tools.
RUN curl -o $DOWNLOADS_PATH/commandlinetools-linux-8512546_latest.zip \
https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip

RUN sha256sum $DOWNLOADS_PATH/commandlinetools-linux-8512546_latest.zip

RUN echo '2ccbda4302db862a28ada25aa7425d99dce9462046003c1714b059b5c47970d8  /tmp/downloads/commandlinetools-linux-8512546_latest.zip' \
> $DOWNLOADS_PATH/commandlinetools-linux-8512546_latest.sha256

RUN sha256sum -c $DOWNLOADS_PATH/commandlinetools-linux-8512546_latest.sha256

RUN unzip $DOWNLOADS_PATH/commandlinetools-linux-8512546_latest.zip -d /usr/bin/android/

RUN rm -r $DOWNLOADS_PATH/*

# Install essential Android Sdk build tools.
RUN yes | sdkmanager --sdk_root=$ANDROID_HOME 'build-tools;31.0.0' 'platforms;android-31'

# Install bundler to use with fastlane.
RUN gem install bundler