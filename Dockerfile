FROM iamdevopstrainer/tomcat:base
RUN rm -rf /usr/local/tomcat/webapps/*
COPY xyz.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
