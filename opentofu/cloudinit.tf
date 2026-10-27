# Disco de cloud-init de cada máquina: usuario, clave SSH y red
resource "libvirt_cloudinit_disk" "init" {
  for_each = local.maquinas

  name = "p1-${each.key}-cloudinit.iso"
  pool = var.pool

  user_data = templatefile("${path.module}/cloud-init/user-data.yaml", {
    hostname  = each.key
    usuario   = var.usuario
    clave_ssh = trimspace(file(pathexpand(var.clave_ssh)))
  })

  network_config = templatefile("${path.module}/cloud-init/network-config.yaml", {
    mac_nat   = each.value.mac_nat
    mac_datos = each.value.mac_datos
    ip_datos  = each.value.ip_datos
  })
}
