FROM openjdk:11
VOLUME /tmp
ARG JAVA_OPTS
ENV JAVA_OPTS=$JAVA_OPTS

RUN apt-get update \
    && apt-get -y install tesseract-ocr

# Copy Gradle files first to leverage Docker cache
COPY build.gradle settings.gradle gradlew /app/
COPY gradle /app/gradle

# Download dependencies
WORKDIR /app
RUN ./gradlew --version

# Copy the rest of the source code
COPY . /app

# Build the project
WORKDIR /app
RUN ./gradlew installDist

# Expose port and set the startup command to run your binary.
EXPOSE 5051

ENTRYPOINT exec ./build/install/idetect/bin/hello-world-server
