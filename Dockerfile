FROM ubuntu:14.04.1

MAINTAINER Maksim Golubev <maksim.golubev72@gmail.com>

# If this variable is set to any value dfferent from "no", the configuration
# of Oracle will be performed at the build stage. This will reduce the time
# of the first run of the container, but significantly increase the size of the image.
ARG configure_on_build=no

ADD assets /assets

# Set password life time inlimited
ADD dbinit/password_life_time_unlimited.sh /dbinit/dbinit.d/00password_life_time_unlimited
ADD dbinit/password_life_time_unlimited /dbinit/password_life_time_unlimited

# Set systemwide NLS_LENGTH_SEMANTICS=CHAR
ADD dbinit/nls_length_semantics_char.sh /dbinit/dbinit.d/05nls_length_semantics_char
ADD dbinit/nls_length_semantics_char /dbinit/nls_length_semantics_char

RUN chmod +x /assets/setup.sh && sync && /assets/setup.sh

EXPOSE 22
EXPOSE 1521
EXPOSE 8080

CMD /usr/sbin/startup.sh && /usr/sbin/sshd -D
