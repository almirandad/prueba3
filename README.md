### Wordpress y Base de datos.
![](https://www.jenx.si/wp-content/uploads/2019/10/gogs-docker-logo.png)

*** usar el siguiente comando para extraer el contenedor:*** 
git clone https://github.com/almirandad/prueba3.git


***  Luego, dirigirse a  la carpeta prueba3 *** 
cd prueba3

*** Dentro del contenedor se creará la imagen con los archivos en el interior del contenedor.*** 
docker build -t nombreimagen:etiqueta .

*** Antes de iniciar el contenedor debemos ir al grupo de seguridad de la instancia y editar reglas de entrada.*** 
Agregar laq regla de entrada tcp puerto 80 anywhere ipv4..
