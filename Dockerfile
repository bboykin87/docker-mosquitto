FROM debian:10.3-slim

RUN apt update && \
  apt upgrade -y && \
  apt install wget gnupg -y && \
  wget http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key && \
  apt-key add mosquitto-repo.gpg.key && \
  wget -O /etc/apt/sources.list.d/mosquitto-buster.list  http://repo.mosquitto.org/debian/mosquitto-buster.list && \
  apt update && apt install mosquitto mosquitto-clients -y && \
  printf "port 58821\n" >> /etc/mosquitto/mosquitto.conf

ADD docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
RUN ln -s /usr/bin/docker-entrypoint.sh docker-entrypoint.sh && chmod +x docker-entrypoint.sh
ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["mosquitto", "-c", "/etc/mosquitto/mosquitto.conf"]

