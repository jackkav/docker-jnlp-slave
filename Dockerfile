
FROM java:8-jdk
MAINTAINER Nicolas De Loof <nicolas.deloof@gmail.com>

ENV HOME /home/jenkins
RUN useradd -c "Jenkins user" -d $HOME -m jenkins && echo "jenkins:jenkins" | chpasswd && chown -R jenkins.jenkins $HOME

RUN apt-get update && apt-get install --no-install-recommends -y -q  \
  build-essential chrpath libssl-dev libxft-dev g++ flex bison gperf ruby perl \
  libsqlite3-dev libfontconfig1 libfontconfig1-dev libicu-dev libfreetype6 libfreetype6-dev libssl-dev \
  libpng-dev libjpeg-dev python libx11-dev libxext-dev bzip2 npm wget sudo sshpass
  
RUN export PHANTOM_JS="phantomjs-2.1.1-linux-x86_64" && \
    wget http://cnpmjs.org/downloads/$PHANTOM_JS.tar.bz2 && \
    mv $PHANTOM_JS.tar.bz2 /usr/local/bin && \
    cd /usr/local/bin && \
    tar xvjf $PHANTOM_JS.tar.bz2 && \
    ln -sf /usr/local/bin/$PHANTOM_JS/bin/phantomjs  /usr/local/bin/phantomjs
RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar http://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/2.52/remoting-2.52.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/slave.jar

COPY jenkins-slave /usr/local/bin/jenkins-slave


RUN curl https://install.meteor.com/ | sh && export PATH=$PATH:$HOME/.meteor && chown -R jenkins.jenkins $HOME/.meteor


VOLUME /home/jenkins
WORKDIR /home/jenkins
USER jenkins

RUN curl https://install.meteor.com/ | sh && export PATH=$PATH:$HOME/.meteor 


ENTRYPOINT ["jenkins-slave"]
