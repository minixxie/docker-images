FROM eclipse-temurin:19.0.1_10-jre

ADD ./update-tz.sh /update-tz.sh

# Timezone updater: https://www.azul.com/products/components/ziupdater-time-zone-tool/
RUN cd /tmp \
	&& curl -sOL https://cdn.azul.com/tools/ziupdater1.1.1.1-jse8+7-any_jvm.tar.gz \
	&& mkdir -p /ziupdater \
	&& tar xzf /tmp/ziupdater1.1.1.1-jse8+7-any_jvm.tar.gz -C /ziupdater \
	&& rm -f /tmp/ziupdater1.1.1.1-jse8+7-any_jvm.tar.gz

# Recommend to add this line to your application's Dockerfil too, to update the tzdb file in every docker image build
# check the latest tzdb file: ls -l $JAVA_HOME/lib/tzdb*
RUN /update-tz.sh
