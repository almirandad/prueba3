<div align="center">
  <img src="https://d1.awsstatic.com/acs/characters/Logos/Docker-Logo_Horizontel_279x131.b8a5c41e56b77706656d61080f6a0217a3ba356d.png" alt="Logo" width="300">
</div>

# Configuración del contenedor docker para WordPress.

### Intalar los siguientes comandos:
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

