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

  # Una tarjeta por cada red de la máquina. Terraform espera a que la de la NAT reciba IP.
  dynamic "network_interface" {
    for_each = each.value.redes
    content {
      network_id     = local.ids_redes[network_interface.value.red]
      mac            = network_interface.value.mac
      wait_for_lease = network_interface.value.red == "nat"
    }
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
