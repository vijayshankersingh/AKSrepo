variable "region" {
  type    = string
  default = "eastus"
  description = " Region where the resource will be created"
  # nullable = false
}

variable "resourcegroup" {
  type    = string
  default = "resource-rg"
  description = " Resource group where the resource will be created"
  # nullable = false
}

variable "project" {
  type    = list(string)
  default = ["humana"]
  description = " Project for which the resource will be created"
  # nullable = false
}
variable secret {
    type = string
    description = "Secrets for apps"
   # nullable=true
    sensitive=true
}
variable userid {
    type = string
    description = "Object id of User to access the AKV"
   # nullable=true
    sensitive=true
}
