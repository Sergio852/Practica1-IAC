# Datos de cada máquina del escenario
locals {
  maquinas = {
    web = {
      imagen    = var.imagen_web
      memoria   = var.memoria_web
      mac_nat   = "52:54:00:01:00:10"
      mac_datos = "52:54:00:02:00:10"
      ip_datos  = var.ip_web_datos
    }
    bd = {
      imagen    = var.imagen_bd
      memoria   = var.memoria_bd
      mac_nat   = "52:54:00:01:00:11"
      mac_datos = "52:54:00:02:00:11"
      ip_datos  = var.ip_bd_datos
    }
  }
}
