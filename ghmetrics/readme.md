# Guía de uso

Este proyecto permite extraer datos de un repositorio de GitHub y generar métricas de manera sencilla. A continuación se describe el proceso de configuración y uso:

## Requisitos previos
- [DotNet 9](https://dotnet.microsoft.com/) o mayor instalado.

## Configuración de variables de entorno
1. Copiar el archivo `.env.sample` a `.env`.
2. Editar `.env` con los valores adecuados:
3. Con el servidor en ejecución:  
   - Ver el sitio estático en `http://localhost:5000` (o el puerto correspondiente).  
   - Explorar datos en `http://localhost:5000/ghapi`.  
   - Consultar métricas en `http://localhost:5000/ghapi/metrics`.

## Personalización
- Ajustar valores en `.env` para cambiar el repositorio que se desea consultar o modificar el token de acceso.
- Modificar los endpoints en `Program.cs` según sea necesario.

Para más detalles, revisar los archivos individuales y el código fuente.