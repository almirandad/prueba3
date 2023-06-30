![](https://miro.medium.com/v2/resize:fit:1400/0*Wq1qEQ4ELhksep5-.jpg)

## Configuración del contenedor docker para WordPress.
Este repositorio contiene un archivo Dockerfile que utiliza una imagen base de Apache en su versión 7.4. Esta imagen proporciona un entorno preconfigurado con PHP y el servidor web Apache que ejecuta una instancia de WordPress.

#### Requisitos previos
sudo yum -y install Docker
sudo yum -y install git
sudo yum -y install mariadb105-server-utils.x86_64

### usar el siguiente comando para extraer el contenedor desde git:
git clone https://github.com/almirandad/prueba3.git

###  Luego, se extraera una carpeta llamada "prueba3", ingresamos dentro de ella.
cd prueba3

### Dentro del contenedor se encontraran todas las dependencias para ejecutar Wordpress, construimos la imagen con el siguinte comando.
docker build -t prueba3:v1 .

### Antes de iniciar el contenedor debemos ir al grupo de seguridad de la instancia y editar reglas de entrada. 
Agregar las regla de entrada tcp puerto 80 anywhere ipv4.

