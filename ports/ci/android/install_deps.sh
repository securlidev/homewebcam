#!/bin/bash

# Webcamoid, webcam capture application.
# Copyright (C) 2017  Gonzalo Exequiel Pedone
#
# Webcamoid is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Webcamoid is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Webcamoid. If not, see <http://www.gnu.org/licenses/>.
#
# Web-Site: http://webcamoid.github.io/

if [ ! -z "${USE_WGET}" ]; then
    export DOWNLOAD_CMD="wget -nv -c"
else
    export DOWNLOAD_CMD="curl --retry 10 -sS -kLOC -"
fi

sudo apt-get -qq -y update
sudo apt-get -qq -y upgrade

# Install dev tools
sudo apt-get -qq -y install \
    ccache \
    cmake \
    gradle \
    libxkbcommon-x11-0 \
    make \
    ninja-build \
    openjdk-8-jdk \
    openjdk-8-jre \
    python3-pip

sudo update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
mkdir -p build
cd build

# Install Android SDK
fileName="commandlinetools-linux-${SDKVER}_latest.zip"
${DOWNLOAD_CMD} "https://dl.google.com/android/repository/${fileName}"

mkdir -p android-sdk
unzip -q -d android-sdk "${fileName}"

# Install Android NDK
fileName="android-ndk-${NDKVER}-linux-x86_64.zip"
${DOWNLOAD_CMD} "https://dl.google.com/android/repository/${fileName}"
unzip -q "${fileName}"
mv -vf "android-ndk-${NDKVER}" android-ndk

# Install Qt for Android
pip install -U pip
pip install aqtinstall
aqt install-qt linux android "${QTVER_ANDROID}" android -O "$PWD/Qt"

cd ..

# Set environment variables for Android build
export JAVA_HOME=$(readlink -f /usr/bin/java | sed 's:bin/java::')
export ANDROID_HOME="${PWD}/build/android-sdk"
export ANDROID_NDK="${PWD}/build/android-ndk"
export ANDROID_NDK_HOME=${ANDROID_NDK}
export PATH="${JAVA_HOME}/bin/java:${PATH}"
export PATH=":${ANDROID_HOME}/tools:${PATH}"
export PATH="${ANDROID_HOME}/tools/bin:${PATH}"
export PATH="${ANDROID_HOME}/cmdline-tools/bin:${PATH}"
export PATH="${ANDROID_HOME}/platform-tools:${PATH}"
export PATH="${ANDROID_HOME}/emulator:${PATH}"
export PATH="${ANDROID_NDK}:${PATH}"

# Install Android things
echo y | sdkmanager \
    --sdk_root="${ANDROID_HOME}" \
    "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "platform-tools" \
    "platforms;android-${ANDROID_PLATFORM}" \
    "tools" > /dev/null
