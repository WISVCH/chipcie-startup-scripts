#!/bin/sh

DOMSERVER_BASEURL=https://dj.chipcie.ch.tudelft.nl/
JUDGEDAEMON_PASSWORD=jd_pass

docker run \
--rm \
-d \
--privileged \
--cpuset-cpus="$1" \
-v /sys/fs/cgroup:/sys/fs/cgroup:ro \
-e DOMSERVER_BASEURL=$DOMSERVER_BASEURL \
-e JUDGEDAEMON_PASSWORD=$JUDGEDAEMON_PASSWORD \
--name judgehost-$1 \
--hostname judgedaemon-$1 \
-e DAEMON_ID=$1 \
ghcr.io/wisvch/domjudge-packaging/judgehost:8.1.2
