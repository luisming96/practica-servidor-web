# Guía de Operación - Servidor de Aplicaciones (RA2)

Este manual describe el funcionamiento y despliegue del servidor basado en Docker con proxy inverso y monitorización.

## 1. Acceso y Requisitos de Red
La VM está configurada en modo **Adaptador Puente** para ser visible en el aula.
- **IP del Servidor:** `192.168.1.16`
- **Acceso para Evaluación:** Para que los dominios funcionen en el equipo del profesor, debe añadir esta línea al archivo `hosts` de su host:
  `192.168.1.16  app-luis.test  panel-proxy.test  portainer.test`

## 2. Gestión de Usuarios
He automatizado el alta para cumplir con el aislamiento de permisos:
- **Script de alta:** `./scripts/crear_usuario.sh` (ejecutar con `sudo`).
- El script crea el usuario, lo añade al grupo `docker` y genera el directorio `~/apps/`.

## 3. Pasos para desplegar una App (Convención)
1. **Subir:** `scp -r ./mi-app usuario@192.168.1.16:~/apps/`
2. **Conectar:** `ssh usuario@192.168.1.16`
3. **Levantar:** `cd ~/apps/mi-app && docker compose up -d`
*Nota: Es obligatorio que el `docker-compose.yml` de la app use la red externa `proxy-network`.*
He incluido una carpeta llamada apps-plantilla/ con una aplicación de prueba lista para ser copiada a su directorio ~/apps/ y ejecutada mediante:  docker compose up -d.

## 4. Dominio y SSL (Let's Encrypt)
1. Acceder al panel: `http://192.168.1.16:81`
2. Crear un **Proxy Host** apuntando al nombre del contenedor y su puerto.
3. En la pestaña **SSL**, solicitar certificado Let's Encrypt y activar **"Force SSL"**.
*Nota: En red local sin IP pública, el reto ACME fallará; se justifica en la memoria.*

## 5. Monitorización y Gestión
- **Métricas:** Grafana en el puerto `3000` (Dashboard 1860 - Node Exporter).
- **Contenedores:** Portainer en el puerto `9000`.

## 6. Mantenimiento Básico
- **Reiniciar plataforma:** `cd plataforma && docker compose up -d --force-recreate`
- **Ver logs:** `docker logs -f [nombre_contenedor]`
