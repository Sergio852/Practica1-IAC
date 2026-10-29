# Máquinas virtuales del escenario
resource "libvirt_domain" "maquina" {
  for_each = local.maquinas

  name      = "p1-${each.key}"
  memory    = each.value.memoria
  vcpu      = 1
  autostart = true
  cloudinit = libvirt_cloudinit_disk.init[each.key].id

  cpu {
    mode = "host-passthrough"
  }

  disk {
    volume_id = libvirt_volume.disco[each.key].id
  }

  # Red NAT con DHCP: Terraform espera a que la máquina reciba IP
  network_interface {
    network_id     = libvirt_network.nat.id
    mac            = each.value.mac_nat
    wait_for_lease = true
  }

  # Red de datos aislada: IP estática puesta por cloud-init
  network_interface {
    network_id = libvirt_network.datos.id
    mac        = each.value.mac_datos
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
    autoport    = true
  }
}
