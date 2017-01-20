#play-centos7
FROM openshift/base-centos7

MAINTAINER Diverrez Erwan <ediverrez@gmail.com>

ENV ACTIVATOR_VERSION 1.3.6
ENV PATH $PATH:/opt/activator-$ACTIVATOR_VERSION-minimal/

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
#install openjdk 1.8
RUN \
  yum update -y && \
  yum install -y --nogpgcheck unzip java-1.8.0-openjdk-devel && \
  yum clean all

#install sudo
#RUN \
#  yum update -y && \
#  yum install -y sudo && \
#  yum clean all


#install sbt
#RUN \ 
#sudo curl https://bintray.com/sbt/rpm/rpm | tee /etc/yum.repos.d/bintray-sbt-rpm.repo
#RUN yum install -y sbt-0.13.13.1 



# install scala 2.11.7
#RUN \
# wget  http://www.scala-lang.org/files/archive/scala-2.11.7.tgz 
#RUN \
# tar -xf scala-2.11.7.tgz && \
# mv scala-2.11.7 scala && \
# echo "" >> /etc/profile && \
# echo "export SCALA_HOME=/opt/scala" >> /etc/profile && \
# source /etc/profile
 

# install play
RUN \
  curl -sOS http://downloads.typesafe.com/typesafe-activator/$ACTIVATOR_VERSION/typesafe-activator-$ACTIVATOR_VERSION-minimal.zip && \
  unzip typesafe-activator-$ACTIVATOR_VERSION-minimal.zip   && \
  rm -f typesafe-activator-$ACTIVATOR_VERSION-minimal.zip


#Config activator and sbt repository
#RUN mkdir /opt/app-root/src/.activator/
#RUN >  /opt/app-root/src/.activator/repositories
#RUN echo "[repositories]" >> /opt/app-root/src/.activator/repositories
#RUN echo "local" >> /opt/app-root/src/.activator/repositories
#RUN echo "activator-launcher-local: file://opt/app-root/src/.activator/repository, [organization]/[module]/(scala_[scalaVersion]/)(sbt_[sbtVersion]/)[revision]/[type]s/[artifact](-[classifier]).[ext]" >> /opt/app-root/src/.activator/repositories
#RUN echo "maven-central" >> /opt/app-root/src/.activator/repositories
#RUN echo "typesafe-releases: https://repo.typesafe.com/typesafe/releases" >> /opt/app-root/src/.activator/repositories
#RUN echo "typesafe-ivy-releasez: https://repo.typesafe.com/typesafe/ivy-releases, [organization]/[module]/(scala_[scalaVersion]/)(sbt_[sbtVersion]/)[revision]/[type]s/[artifact](-[classifier]).[ext]" >> /opt/app-root/src/.activator/repositories

#RUN mkdir /opt/app-root/src/repository
#RUN > /opt/app-root/src/.activator/activatorconfig.txt
#RUN echo "-Dactivator.local.repository=/opt/app-root/src/repository" >> /opt/app-root/src/.activator/activatorconfig.txt
#RUN echo "-Dactivator.home=/opt/app-root/src/" >> /opt/app-root/src/.activator/activatorconfig.txt
#RUN echo "-Dsbt.ivy.home=/opt/app-root/src/repository" >> /opt/app-root/src/.activator/activatorconfig.txt
#RUN echo "-Duser.home=/opt/app-root/src/" >> /opt/app-root/src/.activator/activatorconfig.txt
#RUN echo "-Divy.home=/opt/app-root/src/repository" >> /opt/app-root/src/.activator/activatorconfig.txt
#RUN echo "-Dactivator.checkForUpdates=false" >> /opt/app-root/src/.activator/activatorconfig.txt
#RUN echo "-Dactivator.checkForTemplateUpdates=false" >> /opt/app-root/src/.activator/activatorconfig.txt

RUN chmod a+x /opt/activator-$ACTIVATOR_VERSION-minimal/activator
RUN ln -s  /opt/activator-$ACTIVATOR_VERSION-minimal /opt/activator
WORKDIR /opt/app-root/src/

# Copy the STI scripts from the specific language image to /usr/libexec/s2i
COPY ./.s2i/bin/ /usr/libexec/s2i

#RUN groupadd --gid 1001 s2i && useradd --gid 1001 --uid 1001 -m s2i

RUN chown -R 1001:1001 /opt/app-root 

USER 1001

#VOLUME ["/app"]

#WORKDIR /app

EXPOSE 9000

#CMD ["activator", "run"]
CMD ["usage"]
