FROM ubuntu:22.04

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

ENV ANDROID_HOME=/opt/android
ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
ENV DOWNLOADS_PATH=/tmp/downloads

# Update and install necessary dependencies
RUN apt-get update -qq
RUN yes | apt-get install build-essential curl zip openjdk-11-jdk-headless ruby-dev git openssh-client

# Setup downloads folder for dependencies.
RUN mkdir $DOWNLOADS_PATH

# Download android command line tools.
RUN curl -o $DOWNLOADS_PATH/commandlinetools-linux-8512546_latest.zip \
https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip

# Verify command line tools.
RUN sha256sum $DOWNLOADS_PATH/commandlinetools-linux-8512546_latest.zip

RUN echo '2ccbda4302db862a28ada25aa7425d99dce9462046003c1714b059b5c47970d8  /tmp/downloads/commandlinetools-linux-8512546_latest.zip' \
> $DOWNLOADS_PATH/commandlinetools-linux-8512546_latest.sha256

RUN sha256sum -c $DOWNLOADS_PATH/commandlinetools-linux-8512546_latest.sha256

# Unzip command line tools.
RUN unzip $DOWNLOADS_PATH/commandlinetools-linux-8512546_latest.zip -d $ANDROID_HOME
RUN mkdir $ANDROID_HOME/cmdline-tools/latest
RUN mv $ANDROID_HOME/cmdline-tools/* $ANDROID_HOME/cmdline-tools/latest; exit 0

# Allow being run by others for CI uses.
RUN chmod -R 777 $ANDROID_HOME

# Install essential android sdk tools and accept terms and conditions
RUN yes | sdkmanager 'platform-tools'

# Install bundler to use with fastlane.
RUN gem install bundler

# Clean up temp files
RUN rm -r $DOWNLOADS_PATH/*

# Remove unnecessary packages
RUN yes | apt-get remove --autoremove curl zip