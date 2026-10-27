variable "libvirt_uri" {
  description = "URI de conexión a libvirt"
  type        = string
  default     = "qemu:///system"
}

variable "pool" {
  description = "Pool de almacenamiento donde están las imágenes base"
  type        = string
  default     = "default"
}

variable "imagen_web" {
  description = "Volumen base Debian 13 para el servidor web"
  type        = string
  default     = "debian13-base.qcow2"
}

variable "imagen_bd" {
  description = "Volumen base Ubuntu 26.04 para el servidor de BD"
  type        = string
  default     = "ubuntu2604-base.qcow2"
}

variable "memoria_web" {
  description = "Memoria (MiB) del servidor web"
  type        = number
  default     = 1024
}

variable "memoria_bd" {
  description = "Memoria (MiB) del servidor de base de datos"
  type        = number
  default     = 2048
}

variable "clave_ssh" {
  description = "Ruta a la clave pública SSH que se inyecta en las máquinas"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "red_nat" {
  description = "Rango de la red NAT con DHCP"
  type        = string
  default     = "192.168.234.0/24"
}

variable "ip_web_datos" {
  description = "IP estática de web en la red de datos"
  type        = string
  default     = "10.0.0.10"
}

variable "ip_bd_datos" {
  description = "IP estática de bd en la red de datos"
  type        = string
  default     = "10.0.0.11"
}
