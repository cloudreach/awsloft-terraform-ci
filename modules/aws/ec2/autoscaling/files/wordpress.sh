#!/bin/bash



# Log everything we do.
set -x
exec > /var/log/user-data.log 2>&1


# A few variables we will refer to later...
REGION="${region}"


# Update the packages, install CloudWatch tools.
apt-get update -y
apt-get install -y awslogs awscli
apt-get install python-pip nfs-common -y

mkdir -p /var/www/html/
EC2_AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
echo "$EC2_AZ.${efs_id}.efs.${region}.amazonaws.com:/ /var/www/html/ nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 0 0" >> /etc/fstab

mount -a


# Create a config file for awslogs to push logs to the same region of the cluster.
cat <<- EOF | sudo tee /etc/awslogs/awscli.conf
[plugins]
cwlogs = cwlogs
[default]
region = ${region}
EOF

# Create a config file for awslogs to log our user-data log.
cat <<- EOF | sudo tee /etc/awslogs/config/user-data.conf
	[/var/log/user-data.log]
	file = /var/log/user-data.log
	log_group_name = /var/log/user-data.log
	log_stream_name = {instance_id}
EOF

# Start the awslogs service, also start on reboot.
# Note: Errors go to /var/log/awslogs.log
service awslogs start
chkconfig awslogs on

# Install packages
apt-get install -y apache2 php php-mysql php7.0 php7.0-mysql libapache2-mod-php7.0 php7.0-cli php7.0-cgi php7.0-gd mysql-client sendmail

service apache2 restart

wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp
chmod +x /usr/local/bin/wp


cd /var/www/html/
if ! $(sudo -u www-data /usr/local/bin/wp core is-installed); then

	echo "Download Wordpress"
	wget -q https://wordpress.org/wordpress-4.8.2.tar.gz -O wordpress.tar.gz
	tar -xzf wordpress.tar.gz
	cp ./wordpress/wp-config-sample.php ./wordpress/wp-config.php

	echo "Config Wordpress"
	sed -i "s/'database_name_here'/'${db_name}'/g" ./wordpress/wp-config.php
	sed -i "s/'username_here'/'${db_username}'/g" ./wordpress/wp-config.php
	sed -i "s/'password_here'/'${db_password}'/g" ./wordpress/wp-config.php
	sed -i "s/'localhost'/'${db_host}'/g" ./wordpress/wp-config.php



	mv -f /var/www/html/wordpress/* /var/www/html/
	rm -f /var/www/html/index.html
	rm -rf /var/www/html/wordpress/
	chown www-data:www-data /var/www/html/* -R

	sudo -u www-data /usr/local/bin/wp core install \
	--url='www-${environment}.${route53_domain}' --title='Cloudreach AWS Loft - ${environment}' \
	--admin_user='root' --admin_password='wordpress234' \
  --admin_email='aws-loft@cloudreach.com'

	wget -q
	https://raw.githubusercontent.com/cloudreach/awsloft-terraform-ci/master/resources/AWS_Pop_Up_Loft_Munich.jpg -O /var/www/html/wp-content/themes/twentyseventeen/assets/images/header.jpg

	chown www-data:www-data /var/www/html/wp-content/themes/twentyseventeen/assets/images/header.jpg

fi
