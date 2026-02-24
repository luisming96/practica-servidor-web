FROM nginx:alpine
# Variable que el tutor podrá cambiar al lanzar el contenedor
ENV MENSAJE="Servidor de Luis - RA2"

# Script para que el mensaje sea dinámico
RUN echo '#!/bin/sh' > /entrypoint.sh && \
    echo 'echo "<html><body style=\"background-color: #121212; color: white; font-family: sans-serif; text-align: center; padding-top: 100px;\"><h1>$MENSAJE</h1><p>Desplegado via GitHub Actions</p></body></html>" > /usr/share/nginx/html/index.html' >> /entrypoint.sh && \
    echo 'exec "$@"' >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
