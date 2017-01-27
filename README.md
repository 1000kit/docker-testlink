# 1000kit/testlink

Based on 1000kit/maridb. Installed  Version 1.9.14

update to 1.9.16 not tested yet

can import mysql backup image as start point

## build
Take a Dockerfile and build with the default arguments:

~~~~
$ docker build -t 1000kit/maridb .
~~~~

or simply use the `build.sh` script

## run

~~~~
$ docker run --name=testlink -d -p 8080:8080 -e TESTLINK_ADMIN_PASSWORD=<password> 1000kit/testlink
~~~~

for persistence use a data volume and run:
* data volume container:
~~~~
$ docker run --name=testlinkdb -v /var/lib/mysql 1000kit/testlink true
~~~~

* testlink using persistent data volume:
~~~~
$ docker run --name=testlink -d -p 8080:8080 --volumes-from=testlinkdb -e TESTLINK_ADMIN_PASSWORD=<password> 1000kit/testlink
~~~~

* alternative import mysql backup data (name: mysql_import.sql.gz):
~~~~
$ docker run --name=testlink -d -p 8080:8080 -v <localdir>/mysql_import.sql.gz:/import/mysql_import.sql.gz -e TESTLINK_ADMIN_PASSWORD=<password> 1000kit/testlink
~~~~

* or just easy run docker compose
1. paste mysql_import.sql.gz in `/opt/volumes/1000kit/testlink/import`
2. download docker-compose.yml from github: `https://raw.githubusercontent.com/1000kit/docker-testlink/master/docker-compose.yml`

~~~~
$ docker-compose up
~~~~ 