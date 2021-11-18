FROM tomcat:7.0.70-jre7-alpine
MAINTAINER Ivan Latorre <ivan.latorre@upf.edu>

#copies praat executable.
COPY ./praat /usr/local/bin/praat-master

COPY ../target/praatweb.war /usr/local/tomcat/webapps/praatweb.war

EXPOSE 8080