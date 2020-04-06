FROM khozaei/php-fpm:latest

MAINTAINER Amin khozaei <amin.khozaei@gmail.com>


# Replace for later version
#https://download.moodle.org/download.php/stable38/moodle-latest-38.tgz
ARG VERSION=38

VOLUME ["/var/moodledata"]
VOLUME ["/var/www/html"]

# Let the container know that there is no tty
ENV \
	MOODLE_URL http://0.0.0.0 \
    MOODLE_ADMIN admin \
    MOODLE_ADMIN_PASSWORD Admin~1234 \
    MOODLE_ADMIN_EMAIL admin@example.com \
    MOODLE_DB_HOST '' \
    MOODLE_DB_PASSWORD '' \
    MOODLE_DB_USER '' \
    MOODLE_DB_NAME '' \
    MOODLE_DB_PORT '3306'

COPY ./scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY ./scripts/detect_mariadb.php /opt/detect_mariadb.php

RUN	echo "Installing moodle" && \
		curl https://download.moodle.org/download.php/direct/stable${VERSION}/moodle-latest-${VERSION}.zip -o /tmp/moodle-latest.zip  && \
		rm -rf /var/www/html/index.html && \
		cd /tmp &&	unzip /tmp/moodle-latest.zip && cd / \
		mkdir -p /usr/src/moodle && \
		mv /tmp/moodle /usr/src/ && \
		chown www-data:www-data -R /usr/src/moodle;

RUN  rm -f /tmp/*.zip

RUN chmod a+x /usr/local/bin/entrypoint.sh

COPY ./scripts/moodle-config-fpm.php /usr/src/moodle/config.php

EXPOSE 9000
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["php-fpm"]