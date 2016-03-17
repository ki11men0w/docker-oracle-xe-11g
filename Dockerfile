FROM ubuntu:14.04.1

MAINTAINER Wei-Ming Wu <wnameless@gmail.com>

# If this variable is set to any value dfferent from "no", the configuration
# of Oracle will be performed at the build stage. This will will reduce the time
# of the first run of the container, but significantly increase the size of the image.
ARG configure_on_build=no

ADD assets /assets
RUN /assets/setup.sh

EXPOSE 22
EXPOSE 1521
EXPOSE 8080

CMD /usr/sbin/startup.sh && /usr/sbin/sshd -D
