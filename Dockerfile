# Utiliza una imagen base Apache en su versión 7.4. Esta imagen proporciona un entorno preconfigurado con PHP y el servidor web Apache.
FROM php:7.4-apache

# Variables de entorno para configurar la base de datos de Wordpress,se deben dar los parámetros de la base de datos que ya esta creada.
ENV WORDPRESS_DB_HOST=basedatosale-instance-1.cpo9aixgfro4.us-east-1.rds.amazonaws.com
ENV WORDPRESS_DB_NAME=prueba3
ENV WORDPRESS_DB_USER=admin
ENV WORDPRESS_DB_PASSWORD=Duoc.2023

# Instalar extensiones de PHP requeridas por WordPress, ejecuta comandos dentro del contenedor Docker para instalar y habilitar la extensión de PHP para que WordPress se comunique con la base de datos.
RUN docker-php-ext-install mysqli && \
    docker-php-ext-enable mysqli

# Descarga el archivo comprimido de la última versión de WordPress desde el sitio web oficial de WordPress. Luego, extrae los archivos del archivo comprimido en el directorio "/var/www/html/" que es el directorio raíz del servidor web Apache.
RUN curl -o /tmp/latest.tar.gz -SL https://wordpress.org/latest.tar.gz && \
    tar -xzf /tmp/latest.tar.gz -C /var/www/html --strip-components=1 && \
    rm /tmp/latest.tar.gz && \
    chown -R www-data:www-data /var/www/html/

# Copiar archivo de configuración de Apache.
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf

# Habilitar el módulo de reescritura de Apache.
RUN a2enmod rewrite

#  el contenedor expondrá el puerto 80, que es el puerto por defecto utilizado por el servidor web Apache para escuchar las solicitudes HTTP.
EXPOSE 80

# Iniciar el servidor Apache en segundo plano al iniciar el contenedor.
CMD ["apache2-foreground"]

