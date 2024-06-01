# Use an official Perl runtime as a parent image
FROM perl:latest

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the current directory contents into the container at /usr/src/app, excluding eversolar.ini
COPY --chown=root:root . .

# If you don't have the eversolar.ini in the container, create an empty or default one
# If you already have this file set up on the host, you can skip this RUN command
RUN touch eversolar.ini
RUN touch eversolar.pl

# Install required Perl modules
RUN cpanm IO::Socket::INET \
    && cpanm AppConfig \
    && cpanm JSON \
    && cpanm DBI \
    && cpanm Net::FTP \
    && cpanm File::Copy \
    && cpanm POSIX \
    && cpanm utf8 \
    && cpanm Config::Tiny \
    && cpanm HTTP::Server::Simple::CGI \
    && cpanm DBD::SQLite \
    && cpanm Device::SerialPort

# Update package list and install mosquitto clients
RUN apt-get update && apt-get install -y mosquitto-clients

# Make port 4000 available to the world outside this container
EXPOSE 4000

# Run eversolar.pl when the container launches
CMD ["perl", "./eversolar.pl"]
