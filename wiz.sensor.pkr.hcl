# azure-wiz-sensor.pkr.hcl
packer {
  required_plugins {
    azure = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/azure"
    }
  }
}

variable "wiz_client_id" {
  type = string
}

variable "wiz_client_secret" {
  type      = string
  sensitive = true
}

variable "subscription_id" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "client_id" {
  type = string
}

variable "client_secret" {
  type      = string
  sensitive = true
}

source "azure-arm" "wiz_base" {
  client_id                         = var.client_id
  client_secret                     = var.client_secret
  subscription_id                   = var.subscription_id
  tenant_id                         = var.tenant_id
  
  managed_image_name                = "wiz-sensor-{{timestamp}}"
  managed_image_resource_group_name = "packer-images"
  
  os_type         = "Linux"
  image_publisher = "Canonical"
  image_offer     = "0001-com-ubuntu-server-jammy"
  image_sku       = "22_04-lts"
  
  location = "East US"
  vm_size  = "Standard_D2s_v3"
}

build {
  sources = ["source.azure-arm.wiz_base"]
  
  provisioner "shell" {
    environment_vars = [
        "WIZ_API_CLIENT_ID=${var.wiz_client_id}",
        "WIZ_API_CLIENT_SECRET=${var.wiz_client_secret}",
        "WIZ_INSTALL_ONLY=1"
    ]
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y curl",
      "sudo -E bash -c \"$(curl -L https://downloads.wiz.io/sensor/sensor_install.sh)\""
    ]
  }
}