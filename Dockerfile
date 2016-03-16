FROM ubuntu:14.04.1

MAINTAINER Wei-Ming Wu <wnameless@gmail.com>

# If you set this variable (to any value), the configuration of Oracle will be performed not at the build stage,
# but during the first run of the container. This will significantly reduce the size of the image,
# but will increase the time of the first run of the container.
ARG do_not_configure_on_build

ADD assets /assets
RUN /assets/setup.sh

EXPOSE 22
EXPOSE 1521
EXPOSE 8080

CMD /usr/sbin/startup.sh && /usr/sbin/sshd -D
