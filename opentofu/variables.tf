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
  description = "Memoria (MiB) de cada servidor web"
  type        = number
  default     = 768
}

variable "ips_webs" {
  description = "IP estáticas de cada servidor web en la red de datos y en p1-front"
  type = map(object({
    datos = string
    front = string
  }))
  default = {
    web1 = { datos = "10.0.0.21", front = "10.0.1.21" }
    web2 = { datos = "10.0.0.22", front = "10.0.1.22" }
    web3 = { datos = "10.0.0.23", front = "10.0.1.23" }
  }
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

variable "ip_bd_datos" {
  description = "IP estática de bd en la red de datos"
  type        = string
  default     = "10.0.0.11"
}

variable "usuario" {
  description = "Usuario que se crea en las máquinas para entrar por SSH y Ansible"
  type        = string
  default     = "sergio"
}

variable "imagen_proxy" {
  description = "Volumen base Debian 13 para el proxy"
  type        = string
  default     = "debian13-base.qcow2"
}

variable "memoria_proxy" {
  description = "Memoria (MiB) del proxy"
  type        = number
  default     = 512
}

variable "ip_proxy_front" {
  description = "IP estática del proxy en la red p1-front"
  type        = string
  default     = "10.0.1.10"
}

variable "imagen_docker" {
  description = "Volumen base Debian 13 para la máquina de contenedores"
  type        = string
  default     = "debian13-base.qcow2"
}

variable "memoria_docker" {
  description = "Memoria (MiB) de la máquina de contenedores"
  type        = number
  default     = 1024
}

variable "ip_docker_front" {
  description = "IP estática de la máquina de contenedores en la red p1-front"
  type        = string
  default     = "10.0.1.12"
}
