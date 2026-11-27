# Informe de pruebas

Todas las órdenes de mi equipo se lanzan desde el directorio `ansible/` del repositorio,
después de levantar el escenario con los dos comandos. El certificado de mi CA
(`ansible/pki/ca.crt`) lo genera la receta, y en `/etc/hosts` tengo
`www.sergiomesa.org` y `estado.sergiomesa.org` apuntando a la IP del proxy en la red NAT.

## Modificación 1: proxy inverso con HTTPS

Qué demuestra: la aplicación se sirve por HTTPS a través del proxy, que obliga a usar
HTTPS y protege el formulario limitando las peticiones.

### 1.1. HTTP redirige a HTTPS

* Dónde: en mi equipo, en el directorio `ansible/`
* Orden:

  ```
  curl -sI http://www.sergiomesa.org | grep -E "^HTTP|^Location"
  ```

* Resultado esperado:

  ```
  HTTP/1.1 301 Moved Permanently
  Location: https://www.sergiomesa.org/
  ```

### 1.2. El proxy corta a quien abusa del formulario

* Dónde: en mi equipo, en el directorio `ansible/`
* Orden:

  ```
  for i in $(seq 1 10); do curl -s -o /dev/null -w "%{http_code}\n" --cacert pki/ca.crt https://www.sergiomesa.org/nuevo; done
  ```

* Resultado esperado: las primeras peticiones (unas 6) dan `200` y las siguientes dan `429`
  (demasiadas peticiones). El límite es 1 petición por segundo con una ráfaga de 5.

## Modificación 2: panel de estado con Gatus y Docker Compose

Qué demuestra: el panel funciona publicado por el proxy y sirve para ver al momento qué
parte del escenario falla.

### 2.1. El panel está publicado y todo sale en verde

* Dónde: en el navegador
* Orden: abrir `https://estado.sergiomesa.org`
* Resultado esperado: sale el panel "Estado del escenario", con los grupos Aplicación, Proxy
  y Servidores web, y todos los endpoints en verde (`Healthy`).

### 2.2. El panel detecta cuándo cae un servidor

* Dónde: en mi equipo, en el directorio `ansible/`, y en el navegador
* Orden:

  ```
  ansible web2 -b -a "systemctl stop apache2"
  ```

  Recargar `https://estado.sergiomesa.org` a los 30 segundos (Gatus comprueba cada 30 s), y
  después volver a arrancar la web:

  ```
  ansible web2 -b -a "systemctl start apache2"
  ```

* Resultado esperado: en el panel, `Apache en web2` sale en rojo (`Unhealthy`) y
  `Guestbook por HTTPS` sigue en verde (`Healthy`).

## Modificación 3: alta disponibilidad con tres webs

Qué demuestra: el proxy reparte a los usuarios entre las tres webs, mantiene a cada usuario
en la suya con una cookie, y la aplicación sigue funcionando aunque se caigan webs.

### 3.1. El proxy reparte a los usuarios y cada uno se queda en su web

* Dónde: en mi equipo, en el directorio `ansible/`
* Orden:

  ```
  for i in 1 2 3 4 5 6; do curl -sI --cacert pki/ca.crt https://www.sergiomesa.org | grep X-Servidor; done
  for i in 1 2 3 4; do curl -sI --cacert pki/ca.crt -b "usuario_web=prueba" https://www.sergiomesa.org | grep X-Servidor; done
  ```

* Resultado esperado:
  * Primer bucle (6 usuarios nuevos, sin cookie): aparecen al menos dos webs distintas entre
    `X-Servidor: web1`, `X-Servidor: web2` y `X-Servidor: web3`.
  * Segundo bucle (un mismo usuario, con la cookie `usuario_web=prueba`): las 4 respuestas
    tienen el mismo `X-Servidor`.

### 3.2. Si se caen dos webs, la aplicación sigue

* Dónde: en mi equipo, en el directorio `ansible/`
* Orden:

  ```
  ansible web1,web2 -b -a "systemctl stop apache2"
  for i in 1 2 3 4; do curl -sI --cacert pki/ca.crt https://www.sergiomesa.org | grep -E "^HTTP|X-Servidor"; done
  ansible web1,web2 -b -a "systemctl start apache2"
  ```

* Resultado esperado: las 4 respuestas son `HTTP/1.1 200 OK` con `X-Servidor: web3`;
  ninguna es un `502` ni un `503`.
