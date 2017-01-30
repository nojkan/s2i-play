#play-centos7
FROM openshift/base-centos7

MAINTAINER Diverrez Erwan <ediverrez@gmail.com>

ENV ACTIVATOR_VERSION 1.3.12
ENV PATH $PATH:/opt/app-root/activator-dist-$ACTIVATOR_VERSION/bin
ENV JAVA_HOME /usr/lib/jvm/java/bin
ENV JAVA_OPTS="$JAVA_OPTS -Dsbt.ivy.home=/opt/app-root/src/repository/.ivy2"
ENV _JAVA_OPTIONS="-Duser.home=/opt/app-root/src/repository"

LABEL io.k8s.description="Platform for building and running Play application" \
      io.k8s.display-name="builder play 2.5" \
      io.openshift.expose-services="9000:http" \
      io.openshift.s2i.scripts-url="image:///usr/libexec/s2i" \
      io.s2i.scripts-url="image:///usr/libexec/s2i" \
      io.openshift.tags="builder,Playframework,2.5"

LABEL BZComponent="openshift-s2i-play-docker" \
      Name="openshift3/play-centos7" \
      Version="1.0" \
      Realase="1" \
      Architecture="x86_64"

WORKDIR /opt

#prepare repository directory
RUN mkdir -p /opt/app-root/src/repository

#install openjdk 1.8
RUN \
  yum update -y && \
  yum install -y --nogpgcheck unzip java-1.8.0-openjdk-devel && \
  yum clean all


#install sbt
RUN \ 
curl https://bintray.com/sbt/rpm/rpm | tee /etc/yum.repos.d/bintray-sbt-rpm.repo
RUN yum install -y sbt 

 
WORKDIR /opt/app-root

# install play
RUN \
  curl -sOS http://downloads.typesafe.com/typesafe-activator/$ACTIVATOR_VERSION/typesafe-activator-$ACTIVATOR_VERSION.zip && \
  unzip typesafe-activator-$ACTIVATOR_VERSION.zip   && \
  rm -f typesafe-activator-$ACTIVATOR_VERSION.zip


RUN chmod a+x /opt/app-root/activator-dist-$ACTIVATOR_VERSION/bin/activator
#RUN ln -s  /opt/app-root/activator-dist-$ACTIVATOR_VERSION /opt/activator

WORKDIR /opt/app-root/src/

# Copy the STI scripts from the specific language image to /usr/libexec/s2i
COPY ./.s2i/bin/ /usr/libexec/s2i

RUN chown -R 1001:1001 /opt/app-root 

USER 1001

EXPOSE 9000

CMD ["usage"]
