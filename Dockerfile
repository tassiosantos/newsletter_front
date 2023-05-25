FROM ubuntu:20.04

# Define as variáveis de ambiente necessárias para o Android SDK
ENV ANDROID_SDK_ROOT /usr/local/android-sdk
ENV ANDROID_HOME $ANDROID_SDK_ROOT

# Definir a variável DEBIAN_FRONTEND como noninteractive
ENV DEBIAN_FRONTEND noninteractive

# Instalar as dependências necessárias
RUN apt-get update && \
    apt-get install -y curl git unzip xz-utils libglu1-mesa openjdk-11-jdk clang cmake ninja-build pkg-config
    

# Instalar o Flutter SDK
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:${PATH}"
ENV PATH $PATH:/usr/local/android-sdk/cmdline-tools/latest/bin


ENV PATH $PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/tools/bin

RUN rm -rf /usr/local/android-sdk/platform-tools

RUN curl -o sdk-tools-linux.zip https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip && \
    unzip sdk-tools-linux.zip -d $ANDROID_SDK_ROOT && \
    rm sdk-tools-linux.zip

RUN mkdir -p $ANDROID_SDK_ROOT/cmdline-tools && \
    cd $ANDROID_SDK_ROOT/cmdline-tools && \
    curl -o cmdline-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip && \
    unzip cmdline-tools.zip && \
    mv cmdline-tools latest && \
    rm cmdline-tools.zip && \
    yes | $ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager --licenses


# Instalar componentes do Android SDK
RUN sdkmanager "platform-tools" "platforms;android-30" "build-tools;30.0.3" "extras;android;m2repository" "extras;google;m2repository"

COPY ../newsletter_front /newsletter_front

# Configurar o Flutter
RUN flutter precache
RUN flutter doctor --android-licenses
RUN flutter doctor

