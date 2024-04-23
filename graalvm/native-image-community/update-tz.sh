#!/bin/bash

# check the latest tzdb file: ls -l $JAVA_HOME/jre/lib/tzdb*
cd /tmp \
	&& curl -sOL https://www.iana.org/time-zones/repository/tzdata-latest.tar.gz \
	&& java -jar /ziupdater/ziupdater-1.1.1.1.jar -l file:///tmp/tzdata-latest.tar.gz \
	&& rm -f /tmp/tzdata-latest.tar.gz \
	&& java -jar /ziupdater/ziupdater-1.1.1.1.jar -V

microdnf upgrade tzdata  # can be checked with 'rpm -qi tzdata | grep Version'
