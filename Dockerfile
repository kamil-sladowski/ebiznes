FROM ubuntu:18.04

MAINTAINER Kamil Sladowski <kamil.sladowski@gmail.com>

RUN useradd ujot --create-home

RUN apt-get update
RUN apt-get install -y vim unzip curl git wget ca-certificates


#Java
# Install OpenJDK-8
RUN apt-get install -y openjdk-8-jdk && \
    apt-get clean;
    
# Fix certificate issues
    
RUN apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;

    

# Setup JAVA_HOME -- useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

#Scala
ENV SCALA_VERSION=2.12.8 \
    SCALA_HOME=/usr/share/scala

RUN cd "/tmp" && \
    wget "https://downloads.typesafe.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz" && \
    tar xzf "scala-${SCALA_VERSION}.tgz" && \
    mkdir "${SCALA_HOME}" && \
    rm "/tmp/scala-${SCALA_VERSION}/bin/"*.bat && \
    mv "/tmp/scala-${SCALA_VERSION}/bin" "/tmp/scala-${SCALA_VERSION}/lib" "${SCALA_HOME}" && \
    ln -s "${SCALA_HOME}/bin/"* "/usr/bin/" && \
    rm -rf "/tmp/"*

#SBT
ARG SBT_VERSION=1.2.7

# Install sbt
RUN \
  curl -L -o sbt-$SBT_VERSION.deb https://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get install sbt && \
  sbt sbtVersion


USER ujot

CMD echo "Hello World"
