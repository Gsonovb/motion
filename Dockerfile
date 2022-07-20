
FROM ubuntu:focal
ARG DEBIAN_FRONTEND=noninteractive


WORKDIR /store


ADD metadata.json /store/
ADD install.sh /store/


# Setup Timezone packages and avoid all interaction. This will be overwritten by the user when selecting TZ in the run command
RUN export DEBIAN_FRONTEND=noninteractive; \
    apt-get update  && apt-get install --yes  apt-utils  ca-certificates  curl ffmpeg


RUN chmod +x /store/install.sh &&  /store/install.sh


RUN  apt-get --quiet autoremove --yes && \
    apt-get --quiet --yes clean && \
    rm -rf /var/lib/apt/lists/*

COPY motion.conf /etc/motion/

# R/W needed for motion to update configurations
VOLUME /etc/motion/conf.d
# R/W needed for motion to update Video & images
VOLUME /store



EXPOSE  8080 8081

CMD [ "motion", "-n" ]