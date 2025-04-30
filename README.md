# Proyecto Big Data Energía

Este proyecto configura una base de datos MySQL utilizando Docker para almacenar y gestionar los datos de consumo energético. A continuación se detallan los pasos necesarios para levantar el entorno en tu máquina local.

## Requisitos previos

1.  **Docker Desktop**: Asegúrate de tener Docker Desktop instalado y en funcionamiento. Puedes descargarlo desde [Docker](https://www.docker.com/products/docker-desktop).

2.  **VS Code**: Es recomendable utilizar VS Code como editor de código. Puedes descargarlo desde [Visual Studio Code](https://code.visualstudio.com/).

3.  **Git (opcional)**: Si necesitas hacer cambios o revisar el historial de versiones, también es útil tener Git instalado. Si no lo tienes, puedes descargarlo desde [Git](https://git-scm.com/).

## Instrucciones para levantar el proyecto

### 1. Descomprimir el archivo ZIP

Descomprime el archivo ZIP proporcionado en tu máquina local. Asegúrate de que el contenido quede en una carpeta accesible.

### 2. Abrir el proyecto en VS Code

Una vez que hayas descomprimido el archivo, abre la carpeta del proyecto en VS Code. Puedes hacerlo abriendo VS Code y seleccionando "Abrir carpeta", luego elige la carpeta que contiene los archivos del proyecto.

### 3. Levantar el entorno con Docker

Con Docker Desktop funcionando, abre la terminal dentro de VS Code (o cualquier terminal) y navega a la carpeta donde descomprimiste el proyecto. Ejecuta el siguiente comando para construir las imágenes y levantar los contenedores de Docker:

    
    docker-compose up --build

Este comando descargará la imagen de MySQL si no está presente en tu máquina, y luego construirá y levantará los contenedores de acuerdo con el archivo docker-compose.yml.

### 4. Verificar que el contenedor esté corriendo

Para verificar que el contenedor de MySQL esté funcionando, ejecuta el siguiente comando:

    
    docker ps

Este comando te mostrará todos los contenedores activos. Deberías ver algo similar a esto:

    
    CONTAINER ID   IMAGE       COMMAND                  CREATED              STATUS         PORTS                               NAMES
    da7a2f26a794   docker-db   "docker-entrypoint.s…"   About a minute ago   Up 6 seconds   0.0.0.0:3306->3306/tcp, 33060/tcp   mysql-container

### 5. Acceder a la base de datos MySQL

Una vez que el contenedor esté en ejecución, puedes acceder a la base de datos MySQL utilizando el siguiente comando:

    
    docker exec -it mysql-container mysql -u testuser -p

Cuando se te pida la contraseña, ingresa:

    
    testpass

Una vez dentro de MySQL, puedes seleccionar la base de datos y listar las tablas con los siguientes comandos:

    SHOW DATABASES;
    USE bigdata_energia;
    SHOW TABLES;

### 6. Detener el contenedor

Si deseas detener los contenedores y liberar los recursos utilizados, puedes usar el siguiente comando:

    bash
    docker-compose down

Este comando detendrá y eliminará los contenedores que se hayan creado.
