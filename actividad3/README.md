## El problema con el container image del front end es que NGINX no esta configurado para manejar correctamente las solicitudes de la aplicacion de React, NGINX debe estar configurado para manejar de manera adecuada las solicitudes para que la aplicacion funcione correctamente.

## Como solucion se debe agrregar/crear un archivo de configuracion el nombre podria ser cualquiera pero habria que especificar la ruta y el nombre del archivo, por convension se utiliza el nombre "nginx.conf". El contenido de este archivo para que la aplicacion funcione correctamente podria ser 
<pre>
events{}
http {
    include /etc/nginx/mime.types;
    server {
        listen 80;
        server_name localhost;
        root /usr/share/nginx/html;
        index index.html;
        location / {
            try_files $uri $uri/ /index.html;
        }
    }
}</pre>

## De la misma forma se debe editar el archivo Dockerfile para la construccion de la imagen del front end, agregando la siguiente linea.

<pre>
COPY nginx.conf /etc/nginx/nginx.conf
</pre>

## Quedando el archivo Dockerfile de la aplicacion de la siguiente manera

<pre>
## BUILD
# docker build -t mifrontend:0.1.0-nginx-alpine -f nginx.Dockerfile .
## RUN
# docker run -d -p 3000:80 mifrontend:0.1.0-nginx-alpine
FROM node:18.14.0-buster-slim as compilacion

LABEL developer="jesus guzman" \
      email="susguzman@gmail.com"

ENV REACT_APP_BACKEND_BASE_URL=http://localhost:3800

# Copy app
COPY . /opt/app

WORKDIR /opt/app

# Npm install
RUN npm install

RUN npm run build

# Fase 2
FROM nginx:1.22.1-alpine as runner  
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=compilacion /opt/app/build /usr/share/nginx/html

</pre>

## Finalmente se construye la imagen con los comandos necesarios y al correr el contenedor este error ya no se mostrara.