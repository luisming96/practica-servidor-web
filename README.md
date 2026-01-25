# Guía de Despliegue - Servidor RA2

Este es el manual para operar el servidor. He montado un stack con Docker que incluye el proxy, la monitorización y la gestión de contenedores.

### Configuración de Red
La VM está en **Adaptador Puente**. 
- Puertos abiertos: 80/443 (Web), 81 (Nginx Proxy Manager), 22 (SSH), 3000 (Grafana).
- IP actual: 192.168.1.16 (O la que asigne el DHCP del aula).

### Gestión de Usuarios
He automatizado la creación de usuarios para no perder tiempo con permisos de Linux.
- **Script:** `./scripts/crear_usuario.sh` (ejecutar con sudo).
- El script crea el usuario, lo mete en el grupo `docker` y le deja lista la carpeta `~/apps/`.

### Pasos para desplegar una App
1. Pasar la carpeta por SCP: `scp -r ./carpeta-app usuario@IP:~/apps/`.
2. Conectar por SSH: `ssh usuario@IP`.
3. Levantar: `cd ~/apps/carpeta-app && docker compose up -d`.

### Dominio y SSL
Se gestiona desde el panel de Nginx (puerto 81). Al añadir el Proxy Host, hay que marcar la pestaña de SSL para pedir el certificado de Let's Encrypt y activar el "Force SSL".

### Monitorización
Las métricas se pueden consultar en Grafana (puerto 3000). He conectado Prometheus para que saque los datos de uso de CPU y RAM de cada contenedor.
