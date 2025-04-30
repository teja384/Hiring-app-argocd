# Use Maven and Git to clone and build
FROM maven:3.8.5-openjdk-8

# Install git inside the container
RUN apt-get update && apt-get install -y git

# Set workdir
WORKDIR /app

# Clone your repo
RUN git clone https://github.com/teja384/Hiring-app-argocd.git .

# Build the app
RUN mvn clean package

# Now use Tomcat
FROM tomcat:8.5-jre8

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the built WAR file
COPY --from=0 /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Expose port 8080
EXPOSE 8080

CMD ["catalina.sh", "run"]
