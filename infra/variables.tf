# variables.tf

variable "key_name" {
  description = "Nom de la key pair AWS existante"
  type        = string
}

variable "allowed_cidr" {
  description = "Adresse IP autorisée pour SSH"
  type        = string
}

variable "region" {
  description = "Région AWS"
  type        = string
  default     = "eu-west-3"
}
