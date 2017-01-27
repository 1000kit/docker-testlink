#!/bin/bash


TL_ADMIN_PWD=${TESTLINK_ADMIN_PASSWORD:-'testlink'}

INITDone=false
if [ -d "/var/lib/mysql/mysql" ]; then
 INITDone=true
fi
echo "==> start mysqld"
gosu root chown mysql:mysql /docker-entrypoint.sh
gosu mysql /docker-entrypoint.sh mysqld_safe | tee /tmp/mysqld_console.log 2>&1 &

sleep 5

if [  ${INITDone} == "false" ]; then
	echo "==> initialize databse"
	if [ -e /import/mysql_import.sql.gz ]; then
		zcat /import/mysql_import.sql.gz > /tmp/mysql_import
		gosu mysql mysql -u root -ptestlink  --one-database testlink < /tmp/mysql_import
		
	else
		echo "no data to import found in /import/mysql_import.sql.gz"
		gosu mysql mysql -u testlink -ptestlink -Dtestlink < /var/www/html/testlink/install/sql/mysql/testlink_create_tables.sql
		gosu mysql mysql -u testlink -ptestlink -Dtestlink < /var/www/html/testlink/install/sql/mysql/testlink_create_default_data.sql
	fi
	
	echo "==> upgrade DB"
	#cd /var/www/html/testlink/install/sql/alter_tables
	#for dir in 1.9.1[5-6]; do
	#	echo $dir
	#echo db_schema_update.sql
	#gosu mysql mysql -u root -ptestlink  --one-database testlink < ${dir}/mysql/DB.${dir}/step1/db_schema_update.sql
	#echo z_final_step.sql
	#gosu mysql mysql -u root -ptestlink  --one-database testlink < ${dir}/mysql/DB.${dir}/stepZ/z_final_step.sql
	#done

	echo ${TL_ADMIN_PWD}
	PASS=$(echo -n ${TL_ADMIN_PWD} | md5sum | awk '{print $1}')
	
	echo "update users set password=\"${PASS}\" where login=\"admin\"" > /tmp/updatePass
	gosu mysql mysql -u root -ptestlink  --one-database testlink < /tmp/updatePass
				
else
	echo "no init of db - restart detected"
fi



echo "==> START apache server ..."
gosu root /usr/sbin/apachectl -DFOREGROUND

#end