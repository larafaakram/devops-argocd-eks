# Setup Nexus

1. Run Nexus Docker Container: 
```
docker run -d --name nexus -p 8081:8081 sonatype/nexus3:latest --restart unless-stopped
```

2. Get Nexus Initial Password: 
```
docker exec -it <container_ID> /bin/bash 
cd sonatype-work/nexus3 
cat admin.password
```


# Install SonarQube

1. Run SonarQube Docker Container: 
```
docker run -d --name sonar -p 9000:9000 sonarqube:lts-community --restart unless-stopped
```