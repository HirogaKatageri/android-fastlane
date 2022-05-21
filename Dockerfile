FROM thyrlian/android-sdk:7.2

# Set Work Directory
WORKDIR home/project

# Install Necessary SDK Tools
RUN sdkmanager "build-tools;30.0.3" "platforms;android-30"

# Refresh Package Manager
RUN apt-get update

# Install Ruby and Dev Tools for Fast Lane
RUN apt-get install -y ruby-full ubuntu-dev-tools

# Install Bundler for Fast Lane
RUN gem install bundler

# Create Project Folder
RUN mkdir project; cd project

# Initialize Git Repositoru
RUN git init

# Add remote url
RUN git remote add origin ${GIT_REMOTE_URL}

# Fetch Repository & Reset to Commit
RUN git fetch origin ${CI_COMMIT_SHORT_SHA}; git reset --hard FETCH_HEAD

# Run Bundler Install
RUN bundle install

# Copy Gradle Cache
COPY ./build-cache ./build-cache

# Run Assemble Debug
