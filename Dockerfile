FROM		ubuntu:16.04
LABEL		maintainer=eugene.kim@ntti3.com
USER		root
WORKDIR		/
COPY		["files", "/"]
ARG		ORACLE_JAVA_INSTALL_VERBOSE=false
RUN		["/bin/sh", "/oracle_java_install.sh"]
ENV		JAVA_HOME="/usr/lib/jvm/java-8-oracle"
