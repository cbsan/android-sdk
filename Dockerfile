FROM debian:trixie as sdk

LABEL maintainer="Cristian B. Santos <cbsan.dev@gmail.com>"
LABEL describle="Android SDK"

ENV ANDROID_SDK_URL=https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
ENV ANDROID_HOME=/root/.android
ENV ANDROID_SDK_ROOT=/opt/android/sdk
ENV JDK_VERSION=17
ENV PATH=${PATH}:${ANDROID_SDK_ROOT}/emulator:${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_SDK_ROOT}/tools:${ANDROID_SDK_ROOT}/tools/bin:${ANDROID_SDK_ROOT}/cmdline-tools/bin
ENV JAVA_HOME=/usr/lib/jvm/java-${JDK_VERSION}-openjdk-amd64
ENV TZ=America/Sao_Paulo

RUN apt update && apt install -y \
    curl \
    unzip \
    openjdk-${JDK_VERSION}-jdk \
  && curl -fsSL ${ANDROID_SDK_URL} -o /tmp/sdk.zip \
  && mkdir -p ${ANDROID_SDK_ROOT} \
  && mkdir -p ${ANDROID_HOME} \
  && unzip /tmp/sdk.zip -d "${ANDROID_SDK_ROOT}" \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/* \
  && rm -f /tmp/sdk.zip 