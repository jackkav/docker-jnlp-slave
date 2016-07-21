
FROM java:8-jdk
MAINTAINER Nicolas De Loof <nicolas.deloof@gmail.com>

ENV HOME /home/jenkins
RUN useradd -c "Jenkins user" -d $HOME -m jenkins
RUN apt-get install -y phantomjs
RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar http://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/2.52/remoting-2.52.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/slave.jar

COPY jenkins-slave /usr/local/bin/jenkins-slave

VOLUME /home/jenkins
WORKDIR /home/jenkins
USER jenkins
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.3/install.sh | bash \
   && source .profile \
   && nvm install 5.11.0
RUN curl https://install.meteor.com/ | sh && export PATH=$PATH:$HOME/.meteor 


ENTRYPOINT ["jenkins-slave"]
