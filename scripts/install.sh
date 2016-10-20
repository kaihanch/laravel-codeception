#!/bin/bash
########################################
#                                      #
#  Install Laravel for Ubuntu 14.04    #
#                                      #
########################################

INSTALLED=".installed"

# Setup Timezone
TIMEZONE="UTC"

# Setup pool zone
NTPPOOLZONE="time.stdtime.gov.tw"

# Setup timeout
TIMEOUT="30"

# PHP memory limit
MEMORY="128M"

# Setup packages and version
PACKAGES_LIST="
ntp
git
unzip
php7.0
php7.0-mysql
php7.0-mbstring
php7.0-xml
"

PACKAGES=""
for package in $PACKAGES_LIST
do
    PACKAGES="$PACKAGES $package"
done

# is root?
if [ "`whoami`" != "root" ]; then
    echo "You may use root permission!"
    exit 1
fi

if [ ! -e ${INSTALLED} ];then
    touch ${INSTALLED}

     # set locale
    locale-gen zh_TW.UTF-8

    # Add PHP 7.0 PPA
    add-apt-repository -y ppa:ondrej/php
    apt-get update

    # install general tools
    apt-get install -y ${PACKAGES}


    # modified apache
    APACHE_CONF=/etc/apache2/apache2.conf
    echo "<Directory /vagrant/blog>
        Options FollowSymLinks
        AllowOverride ALL
        Require all granted" >> ${APACHE_CONF}
    echo "</Directory>" >> ${APACHE_CONF}

    sed -i 's|DocumentRoot /var/www/html|DocumentRoot /vagrant/blog/public|' /etc/apache2/sites-available/000-default.conf

    # download composer
    cd /vagrant && curl -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer
fi

# set time zone
echo ${TIMEZONE} | tee /etc/timezone
# changing NTP Time Servers
echo "server ${NTPPOOLZONE}" >> /etc/ntp.conf
# create daily cron job
echo -e "#!/bin/sh \nntpdate ${NTPPOOLZONE}" | tee /etc/cron.daily/ntpdate
chmod 755 /etc/cron.daily/ntpdate
# update time
sh /etc/cron.daily/ntpdate


# modified php.ini
PHP_INI=`php --ini | grep "Loaded Configuration" | sed -e "s|.*:\s*||"`
sed -i "s/^memory_limit =.*/memory_limit = ${MEMORY}/g" ${PHP_INI}
sed -i "s/^max_execution_time =.*/max_execution_time = ${TIMEOUT}/g" ${PHP_INI}
sed -i "s/^error_reporting =.*/error_reporting = E_ALL \| E_STRICT/g" ${PHP_INI}
sed -i "s/^display_errors =.*/display_errors = On/g" ${PHP_INI}
sed -i "s/^display_startup_errors =.*/display_startup_errors = On/g" ${PHP_INI}

# restart services
service apache2 restart