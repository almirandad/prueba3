![](https://miro.medium.com/v2/resize:fit:1400/0*Wq1qEQ4ELhksep5-.jpg)

## Configuración del contenedor docker para WordPress.
_Este repositorio contiene un archivo Dockerfile que utiliza una imagen base de Apache en su versión 7.4. Esta imagen proporciona un entorno preconfigurado con PHP y el servidor web Apache que ejecuta una instancia de WordPress._

**Requisitos previos** 
(instalar Docker, git y mariadb e iniciamos cada servicios según sea necesario).
- sudo yum -y install Docker
- sudo yum -y install git
- sudo yum -y install mariadb105-server-utils.x86_64

## grupos de seguridad instancia:
- launch-wizard-2
   - _grupo de seguruidad que permite conectividad ssh y http a la instancia-ec2_
       - regla: Entrada http puerto 80 / ssh puerto 22 origen: 0.0.0.0/0.
  
## Crear una base de datos:
- Crearemos una base de datos Amazon RDS.
- Tipo Creación estándar.
- Motor Aurora(MySQL Compatible).
- Plantilla de desarrollo y pruebas.
- En dentificador del clúster de base de datos damos un nombre para identificar la base de datos.
- En credenciales se ingresa el nombre de usuario para administrar la base de datos
- Se asigna una contraseña para conectarse a la base de datos.
- En Configuración de la instancia para este ejercicio, la de menor rendimiento.
- Seleccionamos No crear una réplica.
- En Conectividad seleccionamos Conectarse a un recurso informático de EC2 indicando la instancia que esta habilitada.
- Selecionamos autenticación con contraseña.
- Finalmente, presionamos crear base de datos.

**Una vez creada la base de datos, nos conectamos a través del punto de enlace que generamos con la instancia anteriormente conectarse a la base de datos**
- mysql -h Puntodeenlace -P 3306 -u admin -p
  
**Crearemos una base de datos llamada prueba3 y luego con comando show podemos verificar que se creo**
- create database prueba3;
- show databases;
  
**Brindamos los permisos para el usuario admin en la base de datos creada**
- GRANT ALL PRIVILEGES ON prueba3.* TO admin;
- FLUSH PRIVILEGES;


## grupos de seguridad:

**Grupos de bases de datos:**
- ec2-rds-4
   - _grupo de seguruidad que permite la conexión de las intancias que asociadas al sg rds-ec2-4 a la base de datos_
       - regla: salida TCP puerto 3306 origen: rds-ec2-4.
    
- rds-ec2-4
   - _grupo de seguridad que permite la conexión de la base de datos a las instancias que pertenecen al sg ec2-rds-4_
       - regla: entrada TCP puerto 3306 origen: ec2-rds-4.
    
**balanceador de carga y instancia-ec2:**
- launch-wizard-2
   - _se debe asociar a un grupo que le permita conectividad http_
      - regla: regla de entrada http 80 origen 0.0.0.0/0.
      - regla: regla de entrada ssh 22 origen 0.0.0.0/0.
        
**Grupos de destinos**
- prueba3-tg
   - _se debe crear un target group para el balanceador de carga_
      - balanceador de carga de aplicación http 80 
  
**usar el siguiente comando para extraer el contenedor desde git:**
- git clone https://github.com/almirandad/prueba3.git

**Luego, se extraera una carpeta llamada "prueba3", ingresamos dentro de ella.**
- cd prueba3

**Variables de entorno:** 
_El contenedor utiliza variables de entorno para configurar la base de datos de WordPress. Hay que asegúrate de proporcionar los valores correctos antes de construir y ejecutar el contenedor. Las variables de entorno son las siguientes:_

- WORDPRESS_DB_HOST: la dirección del puntodeenlace de la base de datos.
- WORDPRESS_DB_NAME: el nombre de la base de datos.
- WORDPRESS_DB_USER: el nombre de usuario.
- WORDPRESS_DB_PASSWORD: la contraseña de la base de datos.

**Dentro del contenedor se encontraran todas las dependencias para ejecutar Wordpress, construimos la imagen con el siguinte comando.**
- docker build -t prueba3:v1 .

**Para correr la imagen creada, utilizaremos el siguiente comando.**
- docker run -d -p 80:80 --name prueba3run prueba3:v1
  
**se puede acceder a wordpress a traves la ip**
- http://ippublica:80














