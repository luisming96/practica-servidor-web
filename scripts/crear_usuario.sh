#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Por favor, ejecuta el script con sudo."
  exit 1
fi

read -p "Nombre del nuevo usuario: " USUARIO

adduser "$USUARIO"
usermod -aG docker "$USUARIO"

sudo -u "$USUARIO" mkdir -p /home/"$USUARIO"/apps

echo "Usuario $USUARIO creado. Carpeta /home/$USUARIO/apps/ lista."
