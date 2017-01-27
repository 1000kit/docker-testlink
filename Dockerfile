FROM 1000kit/mariadb

MAINTAINER 1000kit <docker@1000kit.org>


LABEL Vendor="1000kit" \
      License=GPLv3 \
      Version=1.0.0

ENV VERSION=1.9.14
USER root

ENV MYSQL_DATABASE=testlink \
	MYSQL_USER=testlink \
	MYSQL_PASSWORD=testlink\
	MYSQL_ROOT_PASSWORD=testlink
	

ADD install/ /tmp
# Install necessary packages
RUN yum update && yum -y install php php-mysql php-gd php-ldap vim && yum clean all \
	&& sed -i "s/Listen 80/Listen 8080/g" /etc/httpd/conf/httpd.conf \
	
	&& mkdir /import\
	&& cd /tmp \
	&& chown apache:apache /tmp/*.sh && chmod 755 /tmp/*.sh && mv /tmp/*.sh /   \
	
	&& if [ ! -e /tmp/testlink-${VERSION}.tar.gz ]; then \
	    wget -q -c https://downloads.sourceforge.net/project/testlink/TestLink%201.9/TestLink%20${VERSION}/testlink-${VERSION}.tar.gz ; \
	   fi \
	&& tar xfpz testlink-${VERSION}.tar.gz \   
	&& mv /tmp/testlink-${VERSION} /tmp/testlink \
	&& mv /tmp/testlink /var/www/html/ \
	&& cp /tmp/config_db.inc.php /var/www/html/testlink \
	&& chown -R apache:apache /var/www/html/testlink
	
USER apache
EXPOSE 8080

# start mysql
# import testlinkDATA as mysql import
# start apache server
CMD ["/start_testlink.sh"]


#end      