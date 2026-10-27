# Disco de cada máquina como clon ligero (copy-on-write) de su imagen base
resource "libvirt_volume" "disco" {
  for_each = local.maquinas

  name             = "p1-${each.key}.qcow2"
  pool             = var.pool
  base_volume_name = each.value.imagen
  base_volume_pool = var.pool
  format           = "qcow2"
}
