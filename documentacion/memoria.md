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
Uso **Nginx Proxy Manager** para gestionar dominios `.test`. 
- **Sobre HTTPS:** El sistema está configurado y preparado para el despliegue de certificados reales mediante el reto HTTP-01 de Let's Encrypt.
 He configurado el stack de Nginx Proxy Manager para gestionar certificados mediante el protocolo ACME.
 Sin embargo, debido a que el entorno de trabajo es una red local (LAN) y el dominio utilizado es de primer nivel reservado (.test),
 la validación HTTP-01 de Let's Encrypt no puede completarse al no haber visibilidad pública desde los servidores de la CA.
 La arquitectura está diseñada para ser "production-ready": en el momento en que el servidor cuente con una IP pública y un FQDN real,
 la emisión y renovación automática de certificados sería inmediata sin cambios en la configuración.
