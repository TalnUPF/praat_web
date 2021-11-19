FROM tomcat:9.0.55-jdk11
MAINTAINER Ivan Latorre <ivan.latorre@upf.edu>

RUN apt-get update \
&& apt-get install -y \
    libgtk2.0-0 \
    libpulse0 \
    libasound2 \
    python
    

    

#copies praat executable.
COPY ./praat-ft-annot /usr/local/bin/praat-master

RUN chmod +x /usr/local/bin/praat-master

COPY ./target/praatweb.war /usr/local/tomcat/webapps/praatweb.war

EXPOSE 8080
