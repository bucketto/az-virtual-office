variable "resource_group_name" {
  description = "Nombre del Resource Group donde se desplegará AVD"
  type        = string
}

variable "host_pool_name" {
  description = "Nombre del Host Pool de AVD"
  type        = string
}

variable "total_users" {
  description = "Número total de usuarios concurrentes. Se desplegará 1 VM cada 2 usuarios (redondeo hacia arriba)."
  type        = number
  validation {
    condition     = var.total_users >= 1
    error_message = "Debe haber al menos 1 usuario."
  }
}

variable "user_upns" {
  description = "Lista de UPNs o grupos de Entra ID que tendrán acceso al Host Pool (array de strings)."
  type        = list(string)
  default     = []
}
