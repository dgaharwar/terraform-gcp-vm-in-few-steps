variable "gcp_project" {
    type = string
}

variable "gcp_region" {
    type = string
}

variable "gcp_private_key" { 
    type = string 
}

variable "gcp_cred" { 
    type = map 
}

variable "vm_name" {
    type = string
}

locals {
    credential = merge(var.gcp_cred, {private_key = "${var.gcp_private_key}"}) 
}
