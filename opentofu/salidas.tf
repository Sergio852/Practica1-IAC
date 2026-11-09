# IP de las máquinas en cada una de sus redes
output "ips" {
  description = "IP de cada máquina en cada una de sus redes"
  value = {
    for nombre, m in local.maquinas : nombre => merge(
      { nat = local.ips_nat[nombre] },
      { for r in m.redes : r.red => r.ip if r.ip != null }
    )
  }
}

# Inventario de Ansible generado a partir de las IP del escenario
resource "local_file" "inventario" {
  filename        = "${path.module}/../ansible/inventario.ini"
  file_permission = "0644"
  content = templatefile("${path.module}/plantillas/inventario.tftpl", {
    grupos   = local.grupos
    ips_nat  = local.ips_nat
    vars_red = local.vars_red
    usuario  = var.usuario
  })
}
