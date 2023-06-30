![](https://miro.medium.com/v2/resize:fit:1400/0*Wq1qEQ4ELhksep5-.jpg)

## Configuración del contenedor docker para WordPress.
_Este repositorio contiene un archivo Dockerfile que utiliza una imagen base de Apache en su versión 7.4. Esta imagen proporciona un entorno preconfigurado con PHP y el servidor web Apache que ejecuta una instancia de WordPress._

**Requisitos previos** 
(instalar Docker, git y mariadb e iniciamos cada servicios según sea necesario).
- sudo yum -y install Docker
- sudo yum -y install git
- sudo yum -y install mariadb105-server-utils.x86_64
  
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

## Grupos de seguridad:

**Grupos de bases de datos:**
- ec2-rds-4
   - _grupo de seguruidad que permite la conexión de las intancias que asociadas al sg rds-ec2-4 a la base de datos_
       - regla: salida TCP puerto 3306 origen: rds-ec2-4.
    
- rds-ec2-4
   - _grupo de seguridad que permite la conexión de la base de datos a las instancias que pertenecen al sg ec2-rds-4_
       - regla: entrada TCP puerto 3306 origen: ec2-rds-4.
    
**Balanceador de carga e instancia-ec2:**
- launch-wizard-2
   - _se debe asociar a un grupo que le permita conectividad http para el balanceador de carga y la instancia, además el puerto ssh para conectarse a la instancia._
      - regla: regla de entrada http 80 origen 0.0.0.0/0.
      - regla: regla de entrada ssh 22 origen 0.0.0.0/0.
        
**Grupos de destinos:**
- prueba3-tg
   - _se debe crear un target group para el balanceador de carga._
      - balanceador de carga de aplicación http 80 
  
**usar el siguiente comando para extraer el contenedor desde git:**
- git clone https://github.com/almirandad/prueba3.git

**Luego, se extraera una carpeta llamada "prueba3", ingresamos dentro de ella.**
- cd prueba3

**Variables de entorno:** 
_El Dockerfile y wp-config.php utilizan variables de entorno para configurar la base de datos de WordPress. Hay que asegúrate de proporcionar los valores correctos antes de construir y ejecutar el contenedor. Las variables de entorno son las siguientes:_

**Dockerfile**
- WORDPRESS_DB_HOST: la dirección del puntodeenlace de la base de datos.
- WORDPRESS_DB_NAME: nombre de la base de datos.
- WORDPRESS_DB_USER: nombre de usuario.
- WORDPRESS_DB_PASSWORD: contraseña de la base de datos.
  
**wp-config.php**
- define( 'DB_NAME', 'nombre de la base de datos' );
- define( 'DB_USER', 'nombre de usuario' );
- define( 'DB_PASSWORD', 'contraseña de la base de datos' );
- define( 'DB_HOST', 'la dirección del puntodeenlace de la base de datos' );

_Definir una contraseña en los siguientes parametros, para fines practicos utilizamos la misma que la DB._
- define( 'AUTH_KEY', 'contraseña de la base de datos' );
- define( 'SECURE_AUTH_KEY', 'contraseña de la base de datos' );
- define( 'LOGGED_IN_KEY', 'contraseña de la base de datos' );
- define( 'NONCE_KEY', 'contraseña de la base de datos' );

### Crear repositorio ECR.
- creamos un repositorio privado.
- Asignamos un nombre.
- Presionamos "crear repositorio"

**En la instancia-ec2 instalamos aws tools**
- curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" 
- unzip awscliv2.zip
  
**Brindamos las credenciales de conexión de acceso las cuales se obtienen de la cuenta de aws**
- mkdir ~/.aws/
- vim ~/.aws/credentials

_[default]_

_aws_access_key_id=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_

_aws_secret_access_key=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_

_aws_session_token=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_

## A continuación, seleccionamos el repositorio creado y presionamos "ver comandos de envío".
_De esta forma crearemos una imagen en el repositorio desde el git clone anteriormente descargado._

- aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 362607667549.dkr.ecr.us-east-1.amazonaws.com
- docker build -t prueba3 .
   - Cuando se complete la creación, etiquete la imagen para poder enviarla a este repositorio:
- docker tag prueba3:latest 362607667549.dkr.ecr.us-east-1.amazonaws.com/prueba3:latest
   - Ejecute el siguiente comando para enviar esta imagen al repositorio de AWS recién creado:
- docker push 362607667549.dkr.ecr.us-east-1.amazonaws.com/prueba3:latest

### Luego, crearemos una definición de tarea en ECS para crear el cluster con la imagen de repositorio.
- Nueva definición de tarea.
- Asignamos un nombre de familia de definición de tarea "unico".
- Definimos un nombre y la uri de la imagen que cargamos en el repositorio.
- Dejamos por defecto el puerto 80 HTTP.
- Presionamos "Siguiente".
- Dejamos "AWS FARGATE" por defecto.
- En rol de tarea y rol de ejecución de tareas seleccionamos "labrole".
- Almacenamiento efímero seleecionamos el valor minímo 21gb.
- Presionamos "siguiente" y luego, "crear".

### Vamos hasta la sección crear clúster.
- Asignamos un nombre.
- Dejamos todos los parametros por defecto y presionamos "crear".
  
**Crear Servicio**
1.	 Estrategia de proveedor de capacidad # ingresamos al cluster
2.	Configuración de implementación Servicio
3.	Familia elegimos nuestra tarea y la version
4.	Nombre del servicio
5.	Tipo de servicio Réplica Tareas deseadas 1
6.	Redes Subredes todas
7.	Grupo de seguridad launch-wizard-1, task-sg, rds-ec2-1, ec2-rds-1
8.	Balanceo de carga
9.	Balanceador de carga de aplicaciones
10.	Crear un nuevo balanceador de carga
11.	Nombre del balanceador de carga
12.	Crear nuevo agente de escucha puerto 80 http
13.	Grupo de destino Crear nuevo grupo de destino elegir el nombre
14.	Crear servicio
Cuando se inicie el balanceador de carga debemos cambiar su security group por el de ALB-SG que tiene la regla de trafico






















**Dentro del contenedor se encontraran todas las dependencias para ejecutar Wordpress, construimos la imagen con el siguinte comando.**
- docker build -t prueba3:v1 .

**Para correr la imagen creada, utilizaremos el siguiente comando.**
- docker run -d -p 80:80 --name prueba3run prueba3:v1
  
**se puede acceder a wordpress a traves la ip**
- http://ippublica:80
















