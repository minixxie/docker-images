FROM eclipse-temurin:19.0.1_10-jdk

RUN cd /usr/local \
	&& wget https://dlcdn.apache.org/maven/maven-3/3.9.5/binaries/apache-maven-3.9.5-bin.tar.gz \
	&& tar xzf apache-maven-3.9.5-bin.tar.gz \
	&& ln -sf /usr/local/apache-maven-3.9.5/bin/mvn /usr/local/bin/mvn \
	&& rm -rf /usr/local/apache-maven-3.9.5-bin.tar.gz
