# Runbook: Servidor de Aplicaciones Web (Práctica RA2)

## 1. Requisitos de red
* **Modo de red:** Adaptador Puente (Bridged) para visibilidad desde otros equipos del aula.
* **IP del Servidor:** 192.168.1.16 (Cambia según la red).
* **Puertos abiertos:**
    * `80/443`: Tráfico web (HTTP/HTTPS).
    * `81`: Administración del Proxy.
    * `3000`: Monitorización (Grafana).
    * `9000/9443`: Gestión (Portainer).

## 2. Cómo crear usuarios
Se recomienda usar el script automatizado incluido en el repositorio:
1. `sudo ./scripts/crear_usuario.sh`
2. El script creará el usuario, lo añadirá al grupo `docker` y generará la carpeta `~/apps/`.

## 3. Cómo desplegar una app (Pasos mínimos)
1. **Transferencia:** Desde el PC local: `scp -r ./nombre-app deploy-alumno@192.168.1.16:~/apps/`.
2. **Despliegue:** Por SSH: `cd ~/apps/nombre-app && docker compose up -d`.

## 4. Cómo añadir un dominio y certificarlo
1. Acceder a `http://192.168.1.16:81`.
2. Añadir un **Proxy Host** con el nombre del dominio.
3. En la pestaña **SSL**, seleccionar "Request a new SSL Certificate" de Let's Encrypt y marcar "Force SSL".

## 5. Cómo comprobar métricas
1. Acceder a Grafana en el puerto `3000`.
2. Consultar el Dashboard para visualizar el estado de CPU, RAM y red de los contenedores.

## 6. Mantenimiento básico
* **Ver estado:** `docker ps`
* **Reiniciar plataforma:** `cd ~/plataforma && docker compose restart`
* **Parar servicios:** `docker compose down`
