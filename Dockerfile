# Use Maven to build the application
FROM maven:3.8.5-openjdk-8 as build

# Set the working directory in the container
WORKDIR /app

# Clone the repository into the working directory
RUN git clone https://github.com/teja384/Hiring-app-argocd.git .

# Verify the repository and pom.xml file exist
RUN ls -al /app && cat /app/pom.xml

# Build the application with Maven
RUN mvn clean package

# Use Tomcat as the base image for the runtime environment
FROM tomcat:8.5-jre8

# Set the working directory in Tomcat
WORKDIR /usr/local/tomcat/webapps/ROOT

# Copy the WAR file from the build image to Tomcat's webapps directory
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Expose the port Tomcat will listen on
EXPOSE 8080

# Start Tomcat when the container runs
CMD ["catalina.sh", "run"]
