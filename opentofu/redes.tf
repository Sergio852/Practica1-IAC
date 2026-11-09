# Red NAT con DHCP: acceso desde el anfitrión y salida a internet
resource "libvirt_network" "nat" {
  name      = "p1-nat"
  mode      = "nat"
  domain    = "p1.local"
  addresses = [var.red_nat]
  autostart = true

  dhcp {
    enabled = true
  }

  dns {
    enabled = true
  }
}

# Red de datos muy aislada: sin NAT, sin DHCP y sin IP en el anfitrión.
# Solo web y bd se comunican por aquí, con IPs estáticas.
resource "libvirt_network" "datos" {
  name      = "p1-datos"
  mode      = "none"
  autostart = true
}

# Red entre el proxy y web: sin NAT, sin DHCP y sin IP en el anfitrión.
resource "libvirt_network" "front" {
  name      = "p1-front"
  mode      = "none"
  autostart = true
}
