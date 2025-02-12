# Usa Ubuntu como base
FROM ubuntu:latest

# Atualiza pacotes e instala dependências
RUN apt update && apt install -y \
    apache2 \
    mysql-server \
    php8.2 \
    php8.2-mysql \
    libapache2-mod-php8.2 \
    curl \
    unzip \
    git \
    xrdp \
    xfce4 \
    xfce4-goodies \
    firefox \
    openjdk-17-jdk \
    wget \
    nano \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Configura Apache
RUN a2enmod rewrite && \
    service apache2 restart

COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf

# Instala Android Studio e Flutter
WORKDIR /opt
RUN wget -q https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2023.3.1.20/android-studio-2023.3.1.20-linux.tar.gz \
    && tar -xzf android-studio-*.tar.gz \
    && rm android-studio-*.tar.gz && \
    wget -q https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.27.0-stable.tar.xz \
    && tar -xf flutter_linux_3.27.0-stable.tar.xz \
    && rm flutter_linux_3.27.0-stable.tar.xz

# Define variáveis de ambiente para Java, Android SDK e Flutter
ENV JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
ENV ANDROID_HOME="/opt/android-studio"
ENV ANDROID_SDK_ROOT="/opt/android-studio"
ENV PATH="$PATH:$ANDROID_HOME/bin:$ANDROID_SDK_ROOT/platform-tools:/opt/flutter/bin"

# Libera todas as portas
RUN iptables -P INPUT ACCEPT && iptables -P OUTPUT ACCEPT && iptables -P FORWARD ACCEPT

# Configura o XRDP para permitir conexões remotas como root
RUN echo "xfce4-session" > /root/.xsession && \
    service xrdp restart

# Define o diretório padrão ao acessar o container
WORKDIR /var/www/html