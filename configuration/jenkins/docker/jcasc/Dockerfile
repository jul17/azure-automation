FROM jenkins/jenkins:2.319.3-lts-jdk8
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false -Dpermissive-script-security.enabled=no_security
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml
RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state
COPY --chown=jenkins:jenkins plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt
COPY casc.yaml /var/jenkins_home/casc.yaml
USER root
RUN apt-get update && apt-get install -y python3 python3-pip
