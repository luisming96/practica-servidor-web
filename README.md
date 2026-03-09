# Servidor de Aplicaciones Web (RA2) - Runbook

Este repositorio contiene la plataforma dockerizada de despliegue para aplicaciones web con:
- Proxy inverso Nginx dinámico (`nginxproxy/nginx-proxy`)
- Certificados HTTPS automáticos (`nginxproxy/acme-companion`)
- Monitorización (`Prometheus` + `Grafana`)
- Gestión de contenedores (`Portainer`)

## 1) Requisitos previos
- VM Linux (Ubuntu/Debian recomendado)
- Docker y Docker Compose instalados
- Acceso SSH al servidor
- DNS público o resolución de dominios en la red del aula

Servidor actual de referencia:
- IP: `192.168.5.44`
- Acceso externo SSH: `ssh -p 2244 luismi@www.servidorgp.somosdelprieto.com`

## 2) Estructura del proyecto
- Plataforma principal: `plataforma/docker-compose.yml`
- Config Prometheus: `plataforma/prometheus.yml`
- Script alta usuarios: `scripts/crear_usuario.sh`
- Plantilla app prueba: `apps-plantilla/app-test/`

## 3) Alta de usuarios de despliegue
Ejecutar en servidor como root/sudo:

```bash
sudo bash scripts/crear_usuario.sh
```

El script:
- crea el usuario
- lo añade al grupo `docker`
- crea `/home/<usuario>/apps/`

## 4) Flujo estándar de despliegue por usuario (SSH + SCP)
1. Subir la app al servidor:

```bash
scp -r ./mi-app usuario@192.168.5.44:~/apps/
# Desde fuera del aula, usar: scp -P 2244 -r ./mi-app luismi@www.servidorgp.somosdelprieto.com:~/apps/
```

2. Conectarse por SSH:

```bash
ssh usuario@192.168.5.44
# Desde fuera del aula, usar: ssh -p 2244 luismi@www.servidorgp.somosdelprieto.com
```

3. Desplegar:

```bash
cd ~/apps/mi-app
docker compose up -d
```

Convención mínima de la app:
- usar red externa `proxy-network`
- declarar `VIRTUAL_HOST` y `LETSENCRYPT_HOST`
- no exponer puertos al host salvo necesidad excepcional

## 5) Despliegue de VitaClick (actual)
Servicio VitaClick en plataforma:
- nombre contenedor: `usabilidad-container`
- dominio activo: `usabilidad2.luisming.servidorgp.somosdelprieto.com`
- volumen web: `/home/luismi/app_vitaclick/Estudio_de_usabilidad/pages`

Comandos:

```bash
cd /home/luismi/practica-servidor-web/plataforma
docker compose up -d usabilidad nginx-proxy ssl-generator
```

Verificación rápida:

```bash
curl -I https://usabilidad2.luisming.servidorgp.somosdelprieto.com
```

## 6) Dominios y HTTPS (Let's Encrypt)
La emisión se hace automáticamente por `acme-companion` cuando detecta:
- `VIRTUAL_HOST`
- `LETSENCRYPT_HOST`

Comprobaciones:

```bash
docker logs --tail 100 nginx-proxy-acme
docker exec nginx-proxy grep -E "^[[:space:]]*server_name[[:space:]]+" /etc/nginx/conf.d/default.conf
```

## 7) Servicios publicados
- App: `https://usabilidad2.luisming.servidorgp.somosdelprieto.com`
- Landing (routing activo): `http://luisming.servidorgp.somosdelprieto.com`
- Portainer: `https://portainer.luisming.servidorgp.somosdelprieto.com`
- Prometheus: `https://prometheus.luisming.servidorgp.somosdelprieto.com`
- Grafana: `https://grafana.luisming.servidorgp.somosdelprieto.com`

Alias de despliegue mantenido:
- `luisming.servidorgp.somosdelprieto.com` permanece configurado en `VIRTUAL_HOST` para la landing.

## 7.1) Evidencias operativas (2026-03-03)
Acceso SSH de despliegue:

```bash
ssh -o BatchMode=yes luismi@192.168.5.44 "echo SSH_OK"
# Resultado: SSH_OK
```

Estado de contenedores:

```bash
docker ps --format 'table {{.Names}}\t{{.Status}}'
```

Resultado observado:
- `usabilidad-container` `Up`
- `nginx-proxy` `Up`
- `nginx-proxy-acme` `Up`
- `portainer` `Up`
- `prometheus` `Up`
- `grafana` `Up`
- `node-exporter` `Up`
- `cadvisor` `Up (healthy)`
- `landing-container` `Up`

Matriz HTTPS validada:

```bash
usabilidad2.luisming.servidorgp.somosdelprieto.com:200
portainer.luisming.servidorgp.somosdelprieto.com:307
prometheus.luisming.servidorgp.somosdelprieto.com:302
grafana.luisming.servidorgp.somosdelprieto.com:302
```

Estado de monitorización (Prometheus `/api/v1/targets`):
- `job=prometheus` -> `health=up`
- `job=node-exporter` -> `health=up`
- `job=cadvisor` -> `health=up`

Nota de despliegue actual:
- `landing` se mantiene enrutado por `VIRTUAL_HOST` sin `LETSENCRYPT_HOST` para no interferir con la emisión de certificados de los servicios principales.

## 8) Monitorización
- Prometheus activo en contenedor `prometheus`
- Grafana activo en contenedor `grafana`
- Dashboard recomendado: Node Exporter Full (ID 1860)

Nota: la configuración actual de `prometheus.yml` incluye targets `prometheus`, `node-exporter` y `cadvisor`, todos operativos en el entorno validado.

## 9) Portainer
- Contenedor: `portainer`
- Acceso HTTPS por subdominio
- Seguridad: credenciales de administrador en primer acceso

## 10) Mantenimiento básico
Recrear plataforma:

```bash
cd /home/luismi/practica-servidor-web/plataforma
docker compose up -d --force-recreate
```

Estado y logs:

```bash
docker ps
docker logs -f nginx-proxy
docker logs -f nginx-proxy-acme
docker logs -f usabilidad-container
```

## 11) Checklist rápido RA2 (estado actual)
- SSH para despliegues: **OK**
- Proxy inverso por dominio: **OK**
- HTTPS real Let's Encrypt: **OK en servicios evaluables (app + herramientas)**
- Prometheus + Grafana operativos: **OK**
- Dashboard coherente en Grafana: **Evidencia requerida en memoria/capturas**
- Portainer operativo y accesible: **OK**
- Servicios dockerizados: **OK**
- Flujo profesor (2-3 apps por SSH/SCP): **Listo para validación**

Observación técnica de arquitectura actual:
- La plataforma usa `proxy-network` para publicación web y `monitoring-network` interna para métricas.
- `node-exporter` y `cadvisor` están integrados para monitorización de host y contenedores.
