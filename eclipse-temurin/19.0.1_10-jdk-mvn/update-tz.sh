#!/bin/bash

cd /tmp \
	&& curl -sOL https://www.iana.org/time-zones/repository/tzdata-latest.tar.gz \
	&& java -jar /ziupdater/ziupdater-1.1.1.1.jar -l file:///tmp/tzdata-latest.tar.gz \
	&& rm -f /tmp/tzdata-latest.tar.gz \
	&& java -jar /ziupdater/ziupdater-1.1.1.1.jar -V
