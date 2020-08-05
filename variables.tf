variable "region" {
  description = "The region to create the infrastructure in"
  type = string
}

variable "vpc_name" {
  description = "The name of the VPC to create for the Minecraft server"
  type = string
}

variable "droplet_name" {
  description = "The name to assign to the Droplet hosting the Minecraft Server"
  type = string
}

variable "firewall_name" {
  description = "The name to assign to the firewall sitting in front of the Droplet hosting the Minecraft server"
  type = string
}

variable "common_tags" {
  description = "Common tags to assign to supporting resources"
  type = set(string)
  default = []
}

variable "droplet_size" {
  description = "The size of the Droplet to create (i.e. CPU and RAM allocations). Exhaustive list here: https://developers.digitalocean.com/documentation/v2/#list-all-sizes."
  type = string
}

variable "droplet_image" {
  description = "The OS image to use on the server. Defaults to Ubuntu 20.04. Will cause issues with the user data if you use an image that doesn't support apt. You can run `doctl compute image list-distribution --public` to get a list."
  type = string
}

variable "minecraft_server_download_path" {
  description = "The URL pointing to the Minecraft server image to install and run"
  type = string
  default = "https://launcher.mojang.com/v1/objects/a412fd69db1f81db3f511c1463fd304675244077/server.jar"
}

variable "minecraft_server_ram" {
  description = "The min/max RAM to allocate to the JVM running the Minecraft server"
  type = object({
    min = string
    max = string
  })

  default = {
    min = "1G",
    max = "1G"
  }

  validation {
    condition = can(regex("^\\d*G$", var.minecraft_server_ram.min))
    error_message = "The value for minecraft_server_ram.min must be a numeric value followed by a 'G'."
  }

  validation {
    condition = can(regex("^\\d*G$", var.minecraft_server_ram.max))
    error_message = "The value for minecraft_server_ram.max must be a numeric value followed by a 'G'."
  }

  validation {
    condition = trim(var.minecraft_server_ram.min, "G") <= trim(var.minecraft_server_ram.max, "G")
    error_message = "The value for minecraft_server_ram.min must be less than or equal the value for to minecraft_server_ram.max."
  }
}

variable "droplet_ssh_keys" {
  description = "List of SSH keys that can access the Droplet"
  type = list(string)
  default = []
}

variable "server_properties_overrides" {
  description = "Overrides for the server.properties default config map in local.server_properties_defaults"
  type = map(string)
  default = {}
}