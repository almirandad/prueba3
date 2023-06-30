![](https://miro.medium.com/v2/resize:fit:1400/0*Wq1qEQ4ELhksep5-.jpg)

## Configuración del contenedor docker para WordPress.
_Este repositorio contiene un archivo Dockerfile que utiliza una imagen base de Apache en su versión 7.4. Esta imagen proporciona un entorno preconfigurado con PHP y el servidor web Apache que ejecuta una instancia de WordPress._

**Requisitos previos** 
(instalar Docker, git y mariadb e iniciamos cada servicios segun sea necesario).
- sudo yum -y install Docker
- sudo yum -y install git
- sudo yum -y install mariadb105-server-utils.x86_64

**Crear una base de datos.**
- Crearemos una base de datos Amazon RDS.
- Tipo Creación estándar.
- Motor Aurora(MySQL Compatible)
- Plantilla de desarrollo y pruebas.
6.	Identificador del clúster de base de datos debemos escribir un nombre a eleccion
7.	En credenciales elegir el nombre de usuario maestro (como es test dejaremos admin)
8.	Contraseña maestra elegir una debe tener al menos 8 caracteres(esto se utilizara para conectarnos a la bd luego)
9.	En Cluster storage configuration elegir Aurora Standard (esto es para los costos bajos)
10.	En Configuración de la instancia elegir Clases con ráfagas e elegir la que consideremos apropiada la small es una bd con 2GB de memoria algo para un sitio estandar con no tanto requisito o flujo de usuario
11.	En Disponibilidad y durabilidad si deseo crear algo resilente a fallos elegir crear nodo si no es el caso y es solo test elegir No crear una réplica de Aurora
12.	En Conectividad elegir Conectarse a un recurso informático de EC2 esto es para establecer una conexion interna con nuestra instancia ec2 con el contenedor y crear los Security Group de conexion de RDS (todas las demas opciones dejar por defecto)
13.	En Autenticación de bases de datos elegir Autenticación con contraseña
14.	dejar todo lo demas por defecto y hacer click en crear base de datos


**verificar grupo de seguridad de la instancia y tenga los permisos necesarios.**
- Agregar las regla de entrada tcp puerto 80 anywhere ipv4.

**usar el siguiente comando para extraer el contenedor desde git:**
- git clone https://github.com/almirandad/prueba3.git

**Luego, se extraera una carpeta llamada "prueba3", ingresamos dentro de ella.**
- cd prueba3

**Dentro del contenedor se encontraran todas las dependencias para ejecutar Wordpress, construimos la imagen con el siguinte comando.**
- docker build -t prueba3:v1 .

**Para correr la imagen creada, utilizaremos el siguiente comando.**
- docker run -d -p 80:80 --name prueba3run prueba3:v1
  
**se puede acceder a wordpress a traves la ip**
- http://ippublica:80

