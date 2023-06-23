FROM debian:trixie

LABEL maintainer="Cristian B. Santos <cbsan.dev@gmail.com>"
LABEL describle="Android SDK"

ENV ANDROID_SDK_URL=https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
ENV ANDROID_HOME=/root/.android
ENV ANDROID_SDK_ROOT=/opt/android/sdk
ENV ANDROID_COMPILE_SDK=30
ENV ANDROID_BUILD_TOOLS=30.0.3
ENV ANDROID_EMULATOR_VERSION=28
ENV JDK_VERSION=17
ENV PATH=${PATH}:${ANDROID_SDK_ROOT}/emulator:${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_SDK_ROOT}/tools:${ANDROID_SDK_ROOT}/tools/bin:${ANDROID_SDK_ROOT}/cmdline-tools/bin
ENV JAVA_HOME=/usr/lib/jvm/openjdk-amd64
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
 && rm -f /tmp/sdk.zip \
  && yes | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} \
    "platforms;android-${ANDROID_COMPILE_SDK}" \
    "build-tools;${ANDROID_BUILD_TOOLS}" \
    "extras;android;m2repository" \
    "extras;google;google_play_services" \
    "extras;google;m2repository" \
    "system-images;android-${ANDROID_EMULATOR_VERSION};default;x86_64" \
    "system-images;android-${ANDROID_EMULATOR_VERSION};google_apis_playstore;x86" \
 && yes | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --licenses || echo "Failed"  \
 && echo "no" | avdmanager create avd -n "emu${ANDROID_EMULATOR_VERSION}" -f -k "system-images;android-${ANDROID_EMULATOR_VERSION};google_apis_playstore;x86" -d "Nexus 4" \
 && echo "function runEmulator() {\n emulator -avd emu${ANDROID_EMULATOR_VERSION} -no-audio -no-boot-anim -gpu off\n}" >> ~/.bashrc