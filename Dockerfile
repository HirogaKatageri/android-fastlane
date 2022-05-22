FROM alpine:latest

# Install  dependencies
RUN apk update
RUN apk add --virtual build-dependencies build-base
RUN apk add curl zip openjdk11 ruby-dev git openssh-client

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk

# Setup downloads folder for dependencies.
RUN mkdir /tmp/downloads

# Download, verify and extract android command line tools.
RUN curl -o /tmp/downloads/commandlinetools-linux-8512546_latest.zip \
https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip

RUN sha256sum /tmp/downloads/commandlinetools-linux-8512546_latest.zip

RUN echo '2ccbda4302db862a28ada25aa7425d99dce9462046003c1714b059b5c47970d8  /tmp/downloads/commandlinetools-linux-8512546_latest.zip' \
> /tmp/downloads/commandlinetools-linux-8512546_latest.sha256

RUN sha256sum -c /tmp/downloads/commandlinetools-linux-8512546_latest.sha256

RUN unzip /tmp/downloads/commandlinetools-linux-8512546_latest.zip -d /usr/bin/android/

ENV ANDROID_HOME=/usr/bin/android
ENV PATH=$PATH:/usr/bin/android/cmdline-tools/bin

RUN rm -r /tmp/downloads/*

# Install essential Android Sdk build tools.
RUN yes | sdkmanager --sdk_root=/usr/bin/android 'build-tools;31.0.0' 'platforms;android-31'

# Install bundler to use with fastlane.
RUN gem install bundler