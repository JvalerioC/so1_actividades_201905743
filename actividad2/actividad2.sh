#!/usr/bin/env bash

#leyendo la variable GITHUB_USER
echo "Ingrese usuario de Github"
read GITHUB_USER

#consultando la URL concatenando la variable GITHUB_USER al final
data=$(curl -s https://api.github.com/users/$GITHUB_USER)
#echo $data, para ver todo lo consultado

# Se utilizara la libreria jq para parsear el JSON, instalar con el siguiente comando sudo apt-get install jq
user=$(echo $data | jq '.login')
user_id=$(echo $data | jq '.id')
user_created_at=$(echo $data | jq '.created_at')

#se imprime el mensaje en consola
msg="Hola ${user}. User ID: ${user_id}. Cuenta fue creada el: ${user_created_at}"
echo $msg

#se obtiene la fecha del sistema
date_sys=$(date +"%d-%m-%Y")

#se crea la carpeta y subcarpeta si esta no existe, este para crear un directorio en la carpeta actual
mkdir -p "./tmp/$date_sys"

#se escribe el mensaje en un archivo llamado saludos.log dentro del directorio
echo $msg >> "./tmp/$date_sys/saludos.log"