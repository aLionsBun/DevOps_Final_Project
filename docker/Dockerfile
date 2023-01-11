# Inheriting official Jenkins image
FROM jenkins/jenkins:latest

# Defining working directory
WORKDIR /home/ec2-user

# Setting env variable to start Jenkins without setup wizard
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

# Setting env variable to point to Jenkins automatic configuration as code (casc) setup file
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml

# Installing Maven (switching to root to install without sudo)
USER root
RUN apt-get update && apt-get install -y maven

# Copying file with plugins to be installed
COPY --chown=jenkins:jenkins plugins.txt /usr/share/jenkins/ref/plugins.txt

# Copying Jenkins seed job setup file
COPY --chown=jenkins:jenkins seedjob.groovy /usr/local/seedjob.groovy

# Copying Jenkins automatic casc setup file
COPY --chown=jenkins:jenkins casc.yaml /var/jenkins_home/casc.yaml

# Installing Jenkins plugins from file
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt