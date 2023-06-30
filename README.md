### Wordpress y Base de datos.
![](https://www.jenx.si/wp-content/uploads/2019/10/gogs-docker-logo.png)

### usar el siguiente comando para extraer el contenedor desde git:
git clone https://github.com/almirandad/prueba3.git

###  Luego, se extraera una carpeta llamada "prueba3", ingresamos dentro de ella.
cd prueba3

### Dentro del contenedor se encontraran todas las dependencias para ejecutar Wordpress, construimos la imagen con el siguinte comando.
docker build -t prueba3:v1 .

### Antes de iniciar el contenedor debemos ir al grupo de seguridad de la instancia y editar reglas de entrada. 
Agregar las regla de entrada tcp puerto 80 anywhere ipv4.
