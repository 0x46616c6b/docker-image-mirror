PREFIX = /usr/local

install:
	cp mirror.sh ${PREFIX}/bin/docker-image-mirror
	chmod 0755 ${PREFIX}/bin/docker-image-mirror
