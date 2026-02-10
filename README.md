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

## 4. Dominio y Automatización de Proxy
1. Sin panel manual: He migrado a una solución de Proxy Inverso Dinámico. Ya no es necesario configurar reglas en un panel web (puerto 81).
2. Detección Automática: El proxy detecta las apps mediante la variable VIRTUAL_HOST definida en el docker-compose.yml de cada aplicación.
3. SSL: El sistema está preparado para integrar el contenedor acme-companion para certificados automáticos.

## 5. Monitorización y Gestión
1. Métricas: Grafana en el puerto 3000 (Dashboard 1860 - Node Exporter).
2. Contenedores: Portainer en el puerto 9000 (Acceso directo para administración).

## 6. Mantenimiento Básico
- **Reiniciar plataforma:** `cd plataforma && docker compose up -d --force-recreate`
- **Ver logs:** `docker logs -f [nombre_contenedor]`