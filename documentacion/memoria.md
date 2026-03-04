# Memoria de Implementación - Servidor de Aplicaciones

### Elección de Arquitectura
He implementado una arquitectura basada en microservicios dockerizados. He separado la **Plataforma** (servicios de sistema) de las **Apps** de usuario para garantizar que un fallo en una aplicación no afecte a la disponibilidad del proxy o la monitorización.

### Diseño de Redes (Aislamiento)
La plataforma trabaja con **proxy-network** como red de entrada para todos los servicios publicados. Las aplicaciones no exponen puertos al host, de forma que el tráfico web entra por Nginx y se enruta por dominio.

Como mejora de arquitectura pendiente, se plantea separar en una red interna adicional los servicios de monitorización para reforzar aislamiento.

### Seguridad y Despliegue
El acceso está restringido a SSH. Mediante el script `crear_usuario.sh`, automatizo la creación de un entorno seguro en `/home/usuario/apps/` y gestiono los permisos del socket de Docker, permitiendo despliegues ágiles sin intervención manual del administrador.

### Datos y Persistencia
Para garantizar que las configuraciones (reglas de proxy, dashboards de Grafana y usuarios de Portainer) sobrevivan a reinicios o fallos del contenedor, he configurado volúmenes persistentes en el host para cada servicio crítico.

### Monitorización (Prometheus + Grafana)
Se ha desplegado Prometheus y Grafana en contenedores operativos. Prometheus recoge sus métricas base y Grafana se usa para visualización con dashboard elegido por el alumno.

Como mejora pendiente para cerrar al 100% la monitorización de host, se recomienda dejar activo **Node Exporter** en la red de monitorización interna.

### Estrategia de Dominios y SSL
"Se ha implementado un sistema de descubrimiento dinámico de servicios con `nginxproxy/nginx-proxy` y `acme-companion`. Esto evita crear reglas manuales por cada app: el despliegue se publica mediante variables de entorno (`VIRTUAL_HOST`, `LETSENCRYPT_HOST`)."

"La renovación de certificados se realiza automáticamente con ACME siempre que el dominio resuelva correctamente y el challenge sea accesible desde internet."

 Sobre el DNS del aula: He visto el servidor DNS que ha subido el profesor. Mi servidor está totalmente preparado para usarlo:
 solo habría que poner mi IP (192.168.1.16) en su configuración. Así, cualquiera en el aula podría entrar a mis webs por su nombre sin tener que andar tocando el archivo hosts a mano.
 Es una solución mucho más profesional para trabajar en red.
