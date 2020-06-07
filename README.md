# Build by KAI VO
# Service Sshd Apache Jconnector Tomcat 
# host:80 => apache => Tomcat
# Apache 80
# Tomcat 80, 8080
# SSh 212

# Command build docker
docker build -t testing .

# Command start docker run
docker run -ti -d -p 80:80 -p 212:22 -p 8080:8080 --name webs testing

# Command exec bash 
docker exec -it webs /bin/bash

# Testing web IP:80, IP:8080, SSH port 212 - root:pass - root:123456