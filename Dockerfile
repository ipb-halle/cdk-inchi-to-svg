FROM ubuntu:20.04

MAINTAINER Kristian Peters (kpeters@ipb-halle.de)

# Install packages
RUN apt-get -y update && apt-get -y dist-upgrade && apt-get -y --allow-unauthenticated install apt-transport-https git make gcc g++ maven openjdk-8-jdk-headless openjdk-8-jre-headless

# Install cdk-inchi-to-svg
WORKDIR /tmp
RUN git clone https://github.com/ipb-halle/cdk-inchi-to-svg && \
    cd cdk-inchi-to-svg && cd cdk-inchi-to-svg && \
    mvn package && \
    for i in $(find . -name "*with-dependencies*jar"); do install -m755 "$i" /usr/local/bin/cdk-inchi-to-svg.jar; done

# Cleanup
RUN apt-get -y --purge --auto-remove remove git make gcc g++ openjdk-8-jdk-headless maven && \
    apt-get -y clean && apt-get -y autoremove && rm -rf /var/lib/{cache,log}/ /tmp/* /var/tmp/*

# CMD
#CMD ["/usr/local/bin/java", "-jar", "/usr/local/bin/cdk-inchi-to-svg.jar"]
ENTRYPOINT ["java", "-jar", "/usr/local/bin/cdk-inchi-to-svg.jar"]

