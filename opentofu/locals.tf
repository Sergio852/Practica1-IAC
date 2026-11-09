# Datos de cada máquina del escenario.
# "redes" lista sus tarjetas: la NAT va siempre la primera (DHCP, ip = null)
# y las demás llevan IP estática.
locals {
  maquinas = {
    proxy = {
      imagen  = var.imagen_proxy
      memoria = var.memoria_proxy
      grupo   = "proxies"
      redes = [
        { red = "nat", mac = "52:54:00:01:00:12", ip = null },
        { red = "front", mac = "52:54:00:03:00:12", ip = var.ip_proxy_front },
      ]
    }
    web = {
      imagen  = var.imagen_web
      memoria = var.memoria_web
      grupo   = "servidores_web"
      redes = [
        { red = "nat", mac = "52:54:00:01:00:10", ip = null },
        { red = "datos", mac = "52:54:00:02:00:10", ip = var.ip_web_datos },
        { red = "front", mac = "52:54:00:03:00:10", ip = var.ip_web_front },
      ]
    }
    bd = {
      imagen  = var.imagen_bd
      memoria = var.memoria_bd
      grupo   = "servidores_bd"
      redes = [
        { red = "nat", mac = "52:54:00:01:00:11", ip = null },
        { red = "datos", mac = "52:54:00:02:00:11", ip = var.ip_bd_datos },
      ]
    }
  }

  # ID de cada red, para enlazar las tarjetas de las máquinas
  ids_redes = {
    nat   = libvirt_network.nat.id
    datos = libvirt_network.datos.id
    front = libvirt_network.front.id
  }

  # IP de cada máquina en la red NAT (la que da el DHCP)
  ips_nat = {
    for nombre, m in libvirt_domain.maquina :
    nombre => m.network_interface[0].addresses[0]
  }

  # Variables de red de cada máquina para el inventario: ip_datos=... ip_front=...
  vars_red = {
    for nombre, m in local.maquinas :
    nombre => join(" ", [for r in m.redes : "ip_${r.red}=${r.ip}" if r.ip != null])
  }

  # Máquinas agrupadas por grupo de Ansible
  grupos = {
    for nombre, m in local.maquinas : m.grupo => nombre...
  }
}
