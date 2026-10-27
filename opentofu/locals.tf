# Datos de cada máquina del escenario
locals {
  maquinas = {
    web = {
      imagen  = var.imagen_web
      memoria = var.memoria_web
    }
    bd = {
      imagen  = var.imagen_bd
      memoria = var.memoria_bd
    }
  }
}
