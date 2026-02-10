# Memoria de Implementación - Servidor de Aplicaciones

### Elección de Arquitectura
He implementado una arquitectura basada en microservicios dockerizados. He separado la **Plataforma** (servicios de sistema) de las **Apps** de usuario para garantizar que un fallo en una aplicación no afecte a la disponibilidad del proxy o la monitorización.

### Diseño de Redes (Aislamiento)
He diseñado dos redes diferenciadas para cumplir con los requisitos de seguridad:
- **proxy-network:** Red de entrada. Las apps no exponen puertos al host (están protegidas), obligando a que todo el tráfico pase por el Nginx Proxy Manager.
- **monitoring-network:** Red interna para el tráfico de métricas entre Prometheus, Node Exporter y Grafana, aislada del tráfico web.

### Seguridad y Despliegue
El acceso está restringido a SSH. Mediante el script `crear_usuario.sh`, automatizo la creación de un entorno seguro en `/home/usuario/apps/` y gestiono los permisos del socket de Docker, permitiendo despliegues ágiles sin intervención manual del administrador.

### Datos y Persistencia
Para garantizar que las configuraciones (reglas de proxy, dashboards de Grafana y usuarios de Portainer) sobrevivan a reinicios o fallos del contenedor, he configurado volúmenes persistentes en el host para cada servicio crítico.

### Monitorización (Prometheus + Grafana)
He implementado un stack de monitorización real usando **Node Exporter** para obtener métricas del hardware de la VM. El dashboard configurado permite vigilar el consumo de CPU y RAM de cada contenedor, permitiendo identificar aplicaciones que abusen de los recursos del sistema.

### Estrategia de Dominios y SSL
"He implementado un sistema de Service Discovery basado en contenedores. Uso el proxy de jwilder/nginx-proxy porque permite una automatización total: el administrador no tiene que crear reglas manualmente. Esto elimina errores humanos y garantiza que las aplicaciones de los usuarios se publiquen al instante siguiendo la convención de variables de entorno."

"La renovación de los certificados está configurada de forma automática.
 Nginx Proxy Manager incluye un servicio interno que comprueba la validez de los certificados y lanza el proceso de renovación 30 días antes de su expiración,
 siempre que el reto ACME sea accesible."

 Sobre el DNS del aula: He visto el servidor DNS que ha subido el profesor. Mi servidor está totalmente preparado para usarlo:
 solo habría que poner mi IP (192.168.1.16) en su configuración. Así, cualquiera en el aula podría entrar a mis webs por su nombre sin tener que andar tocando el archivo hosts a mano.
 Es una solución mucho más profesional para trabajar en red.
