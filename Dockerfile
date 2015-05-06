FROM debian:stable
MAINTAINER Lukas Novy "lukas.novy@pirati.cz"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

RUN apt-get install -y libpulse0 pulseaudio

RUN apt-get install -y openssh-server mumble

RUN useradd -m -d /home/docker docker
RUN echo "docker:docker" | chpasswd

RUN mkdir -p /var/run/sshd
RUN echo X11Forwarding yes >> /etc/ssh/ssh_config

RUN mkdir /home/docker/.ssh
RUN chown -R docker:docker /home/docker
RUN chown -R docker:docker /home/docker/.ssh

RUN localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 || true
RUN echo "Europe/Prague" > /etc/timezone

RUN echo 'export PULSE_SERVER="tcp:localhost:64713"' >> /usr/local/bin/mumble-pulseaudio
RUN echo 'PULSE_LATENCY_MSEC=60 mumble "$@"' >> /usr/local/bin/mumble-pulseaudio
RUN chmod 755 /usr/local/bin/mumble-pulseaudio


EXPOSE 22

ENTRYPOINT ["/usr/sbin/sshd",  "-D"]
