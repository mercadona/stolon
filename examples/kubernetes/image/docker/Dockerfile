ARG PGVERSION

FROM --platform=linux/amd64 postgres:$PGVERSION

RUN useradd -ms /bin/bash stolon

EXPOSE 5432

# copy the agola-web dist
COPY stolon-proxy /usr/local/bin
COPY stolon-sentinel /usr/local/bin
COPY stolon-keeper /usr/local/bin
COPY stolonctl /usr/local/bin

RUN chmod +x /usr/local/bin/stolon-keeper /usr/local/bin/stolon-sentinel /usr/local/bin/stolon-proxy /usr/local/bin/stolonctl
