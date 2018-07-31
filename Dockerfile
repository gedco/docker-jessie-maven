# Gedco oracle-jdk-8u171 + Maven 3.5.4 base dev image.
#
# Build usage: docker build -t gedco:jessie-maven --pull --rm .
#   Run usage: docker run --name maven-testapp --rm -d -it -v $(pwd)/src:/usr/src/ gedco:jessie-maven /bin/bash
#        Stop: docker stop maven-testapp
#
FROM debian:jessie

# Mark this system as noninteractive.
ENV DEBIAN_FRONTEND noninteractive
ENV MAVEN_VERSION 3.5.4
ENV PATH /opt/apache-maven-${MAVEN_VERSION}/bin:${PATH}

# Install and configure all the software. Clean.
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886; \
    echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main"  > /etc/apt/sources.list.d/webupd8team.list; \
    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections; \
    echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections; \
    apt-get update; apt-get --yes upgrade; \
    apt-get install --yes --no-install-recommends oracle-java8-installer oracle-java8-set-default curl less nano; cd /opt/; \
    wget http://www.eu.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz; \
    tar -xzf apache-maven-${MAVEN_VERSION}-bin.tar.gz; export PATH=/opt/apache-maven-${MAVEN_VERSION}/bin:$PATH; \
    echo "------------ DONE -------------"; mvn -version; \
    rm -rf /var/cache/oracle-jdk8-installer; apt-get clean; rm -rf /var/lib/apt/lists/*

# Default bash command.
CMD ["/bin/bash"]

# Expose port if you run a webapp.
EXPOSE 8084
