# Memoria de Implementación - Servidor de Aplicaciones

### Elección de Arquitectura
He decidido montar todo sobre Docker porque me parece la forma más limpia de aislar los servicios. He separado la parte de la "infraestructura" (proxy, métricas, etc.) de las aplicaciones de los usuarios para que si una app peta, no se caiga todo el servidor.

### Diseño de Redes
He creado dos redes:
- **proxy-network:** Aquí van el proxy y las apps. Las apps no tienen puertos abiertos al host, así que todo el tráfico tiene que pasar por el Nginx sí o sí.
- **monitoring-network:** Una red interna para que Prometheus lea los datos de los contenedores y se los pase a Grafana.

### Seguridad y Despliegue
Para cumplir con lo que pedía la práctica, el servidor se administra solo por SSH. He limitado los despliegues a la carpeta `~/apps/` de cada usuario. Con el script de creación de usuarios me aseguro de que cualquiera que entre tenga los permisos de Docker bien puestos desde el principio.

### Datos y Persistencia
Para no perder las configuraciones cada vez que se pare un contenedor, he mapeado volúmenes para el Nginx, los certificados de Let's Encrypt y las bases de datos de Grafana y Portainer.
