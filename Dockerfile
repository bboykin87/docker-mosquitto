FROM debian:10.3-slim

# Create user and group mosquitto, no home directory
RUN useradd --system mosquitto
# Update and upgrade packages install wget and gnupg for security keys
# Removing wget, gnupg
RUN apt update && \
  apt upgrade -y && \
  apt install wget gnupg -y && \
  wget http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key && \
  apt-key add mosquitto-repo.gpg.key && \
  wget -O /etc/apt/sources.list.d/mosquitto-buster.list  http://repo.mosquitto.org/debian/mosquitto-buster.list && \
  apt update && apt install mosquitto -y && \
  printf "port 58821\n" >> /etc/mosquitto/mosquitto.conf &&\
  apt purge wget gnupg -y && apt autoremove -y

USER mosquitto
ADD docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
RUN ln -s /usr/bin/docker-entrypoint.sh docker-entrypoint.sh && chmod +x docker-entrypoint.sh
ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["mosquitto", "-c", "/etc/mosquitto/mosquitto.conf"]


