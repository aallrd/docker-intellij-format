FROM debian:buster-slim

MAINTAINER coretech-infrastructure@murex.com

RUN apt-get update && \
    apt-get install -y wget tar libfreetype6-dev && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    echo 'Downloading IntelliJ IDEA' && \
    wget https://download-cf.jetbrains.com/idea/ideaIC-2018.2.5.tar.gz -O /tmp/intellij.tar.gz -q && \
    echo 'Installing IntelliJ IDEA' && \
    mkdir -p /opt/intellij && \
    tar -xf /tmp/intellij.tar.gz --strip-components=1 -C /opt/intellij && \
    rm /tmp/intellij.tar.gz

# Dirty trick to remove the IntelliJ configuration directory created on the fly
RUN echo 'rm -rf ?' >> /opt/intellij/bin/idea.sh

ADD groovy-code-style.xml /opt/intellij  

WORKDIR /data

ENTRYPOINT ["/opt/intellij/bin/format.sh", "-settings", "/opt/intellij/groovy-code-style.xml"]
