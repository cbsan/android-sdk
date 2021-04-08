FROM debian:stretch

LABEL maintainer="Cristian B. Santos <cbsan.dev@gmail.com>"
LABEL describle="Android SDK"

ENV ANDROID_SDK_URL=https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip
ENV ANDROID_HOME=/opt/android_sdk
ENV ANDROID_SDK_ROOT=$ANDROID_HOME
ENV ANDROID_COMPILE_SDK=30
ENV ANDROID_BUILD_TOOLS=30.0.3
ENV LANG en_US.UTF-8
ENV PATH=$PATH:$ANDROID_HOME:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$ANDROID_HOME/cmdline-tools/bin

RUN apt update \
  && apt install -y --no-install-recommends \
    git \
    curl \
    unzip \
    gcc \
    openjdk-8-jdk \
    locales \
    libstdc++6 \
    lib32stdc++6 \
    libglu1-mesa \
    build-essential \
  && locale-gen en_US ${LANG} \
  && dpkg-reconfigure locales \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL $ANDROID_SDK_URL -o /tmp/sdk.zip \ 
  && mkdir -p "${ANDROID_HOME}" \
  && mkdir -p ~/.android \
  && unzip /tmp/sdk.zip -d "${ANDROID_HOME}" \
  && yes | sdkmanager --sdk_root=$ANDROID_HOME \
    "platform-tools" \
    "platforms;android-${ANDROID_COMPILE_SDK}" \
    "build-tools;${ANDROID_BUILD_TOOLS}" \
    "extras;android;m2repository" \
    "extras;google;google_play_services" \
    "extras;google;m2repository" \
    "emulator" \
  && yes | sdkmanager --sdk_root=$ANDROID_HOME --licenses || echo "Failed" \
  && rm /tmp/sdk.zip