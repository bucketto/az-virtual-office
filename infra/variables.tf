# Subscription id para terraform
variable "subscription_id" {
  type        = string
  description = "ID de la suscripción de Azure"
}

# POST form variables

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
  type = string
  description = "String con UPNs separados por comas, p.ej. \"user1@dominio.com,user2@dominio.com\""
  default = ""
}
