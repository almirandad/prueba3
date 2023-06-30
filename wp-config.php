#crear el siguiente archivo necesario para crear dockerfile#
<VirtualHost *:80>
    ServerName localhost
    DocumentRoot /var/www/html

    <Directory /var/www/html>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

[root@ip-172-31-16-149 prueba3]# cat wp-config.php
<?php
define( 'DB_NAME', 'prueba3' );
define( 'DB_USER', 'admin' );
define( 'DB_PASSWORD', 'Duoc.2023' );
define( 'DB_HOST', 'basedatosale.cluster-ro-cpo9aixgfro4.us-east-1.rds.amazonaws.com' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

define( 'AUTH_KEY', 'Duoc.2023' );
define( 'SECURE_AUTH_KEY', 'Duoc.2023' );
define( 'LOGGED_IN_KEY', 'Duoc.2023' );
define( 'NONCE_KEY', 'Duoc.2023' );

$table_prefix = 'wp_';

define( 'WP_DEBUG', false );
define( 'WP_MEMORY_LIMIT', '64M' );

if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', _DIR_ . '/' );
}

require_once ABSPATH . 'wp-settings.php';
