FROM debian:stretch

LABEL maintainer="Cristian B. Santos <cbsan.dev@gmail.com>"
LABEL describle="Android SDK"

ENV ANDROID_SDK_URL=https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip
ENV ANDROID_TOOLS_ROOT=/opt/android_sdk
ENV CMD_SDK_MANAGER=$ANDROID_TOOLS_ROOT/cmdline-tools/bin/sdkmanager --sdk_root=$ANDROID_TOOLS_ROOT
ENV ANDROID_COMPILE_SDK=30
ENV ANDROID_BUILD_TOOLS=30.0.3
ENV PATH=$PATH:$ANDROID_TOOLS_ROOT:$ANDROID_TOOLS_ROOT/platform-tools/

RUN apt update \
  && apt install -y \
    git \
    curl \
    unzip \
    gcc \
    openjdk-8-jdk \
    libglu1-mesa \
  && apt clean

RUN curl -fsSL $ANDROID_SDK_URL -o /tmp/sdk.zip \ 
  && mkdir -p "${ANDROID_TOOLS_ROOT}" \
  && mkdir -p ~/.android \
  && unzip /tmp/sdk.zip -d "${ANDROID_TOOLS_ROOT}" \
  && echo "y" | $CMD_SDK_MANAGER \
    "platform-tools" \
    "emulator" \
    "platforms;android-${ANDROID_COMPILE_SDK}" \
    "build-tools;${ANDROID_BUILD_TOOLS}" \
    "extras;android;m2repository" \
    "extras;google;google_play_services" \
    "extras;google;m2repository" \
  && yes | $CMD_SDK_MANAGER --licenses || echo "Failed" \
  && rm /tmp/sdk.zip