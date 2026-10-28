# IP de las máquinas en las dos redes
output "ips" {
  description = "IP de cada máquina en la red NAT y en la red de datos"
  value = {
    for nombre, m in local.maquinas : nombre => {
      nat   = local.ips_nat[nombre]
      datos = m.ip_datos
    }
  }
}

# Inventario de Ansible generado a partir de las IP del escenario
resource "local_file" "inventario" {
  filename        = "${path.module}/../ansible/inventario.ini"
  file_permission = "0644"
  content = templatefile("${path.module}/plantillas/inventario.tftpl", {
    grupos   = local.grupos
    ips_nat  = local.ips_nat
    maquinas = local.maquinas
    usuario  = var.usuario
  })
}
