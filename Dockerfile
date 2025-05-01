# Dockerfile to build PirateLiveApp debug APK without Android Studio
FROM openjdk:17-jdk-slim

# Install required tools
RUN apt-get update && apt-get install -y wget unzip && rm -rf /var/lib/apt/lists/*

# Setup Android SDK
ENV ANDROID_SDK_ROOT=/sdk
RUN mkdir -p $ANDROID_SDK_ROOT/cmdline-tools
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O /tmp/cmdline.zip \
    && unzip /tmp/cmdline.zip -d $ANDROID_SDK_ROOT/cmdline-tools \
    && mv $ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools $ANDROID_SDK_ROOT/cmdline-tools/latest \
    && yes | $ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager --sdk_root=$ANDROID_SDK_ROOT \
       "platform-tools" "platforms;android-34" "build-tools;33.0.1" \
    && yes | $ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager --licenses --sdk_root=$ANDROID_SDK_ROOT

# Copy project
WORKDIR /app
COPY . /app

# Build APK
RUN chmod +x gradlew && ./gradlew assembleDebug --no-daemon --stacktrace
