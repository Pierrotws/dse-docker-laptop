#!/usr/bin/env bash

#WILL evolve
DSEVER=6.8.13
HEAP=2048m

#May be tweaked
PORT_MAPPING="9042:9042"
EXTRA_OPTS="-Xmx${HEAP} -Xms${HEAP} -Ddse.thread_monitor_sleep_nanos=250000 -Ddse.thread_monitor_auto_calibrate=false"

#Should not change
DOK=Dockerfile 
COMP=compose.yaml

cat > $DOK <<END
FROM datastax/dse-server:$DSEVER
ENV DS_LICENSE accept
ENV DC DC1
ENV JVM_EXTRA_OPTS "${EXTRA_OPTS}"
ENV NUM_TOKENS 16
END

cat > $COMP <<END
version: "3"
services:
  dse:
    image: datastax/dse-server:$DSEVER
    environment:
    - DS_LICENSE=accept
    - JVM_EXTRA_OPTS=${EXTRA_OPTS}
    - DC=DC1
    - NUM_TOKENS=16
    ports:
    - "9042:9042"

END

cat <<END
---- Docker only -----
docker build -t dse-laptop:$DSEVER .
docker run --name dse -p '${PORT_MAPPING}' dse-laptop:$DSEVER -s
---- Docker Compose ---
docker-compose up
END
