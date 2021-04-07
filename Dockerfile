FROM debian:stretch

LABEL maintainer="Cristian B. Santos <cbsan.dev@gmail.com>"
LABEL describle="Android SDK"

ENV ANDROID_SDK_URL=https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip
ENV ANDROID_TOOLS_ROOT=/opt/android_sdk
ENV ANDROID_COMPILE_SDK=30
ENV ANDROID_BUILD_TOOLS=30.0.3
ENV PATH=$PATH:$ANDROID_TOOLS_ROOT:$ANDROID_TOOLS_ROOT/platform-tools:$ANDROID_TOOLS_ROOT/tools:$ANDROID_TOOLS_ROOT/cmdline-tools/bin

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
  && yes | sdkmanager --sdk_root=$ANDROID_TOOLS_ROOT \
    "platform-tools" \
    "platforms;android-${ANDROID_COMPILE_SDK}" \
    "build-tools;${ANDROID_BUILD_TOOLS}" \
    "extras;android;m2repository" \
    "extras;google;google_play_services" \
    "extras;google;m2repository" \
  && yes | sdkmanager --sdk_root=$ANDROID_TOOLS_ROOT --licenses || echo "Failed" \
  && rm /tmp/sdk.zip

  RUN yes | sdkmanager --sdk_root=$ANDROID_TOOLS_ROOT "emulator" "system-images;android-28;default;x86_64" "system-images;android-28;google_apis_playstore;x86" \
     && avdmanager create avd -n emu28 -f -k "system-images;android-28;google_apis_playstore;x86" -d "Nexus 4" 
    #  && echo "function openEmulator() {\n   $ANDROID_TOOLS_ROOT/emulator -avd emu28 -noaudio -no-boot-anim -gpu off\n}" >> ~/.bashrc

  # $ANDROID_TOOLS_ROOT/tools/bin/avdmanager create avd -k 'system-images;android-18;google_apis;x86' --abi google_apis/x86 -n 'test' -d 'Nexus 4'
  # $ANDROID_TOOLS_ROOT/tools/bin/emulator -avd test -no-skin -no-audio -no-window