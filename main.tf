resource "digitalocean_vpc" "vpc" {
  name     = var.vpc_name
  region   = var.region
}

//Create a droplet for the minecraft server
resource "digitalocean_droplet" "server" {
  name     = var.droplet_name
  size     = var.droplet_size
  image    = var.droplet_image
  region   = var.region
  vpc_uuid = digitalocean_vpc.vpc.id
  tags = var.common_tags
  user_data = templatefile("./minecraft_server.tmpl", {
    MINECRAFT_SERVER_DOWNLOAD_PATH = var.minecraft_server_download_path,
    MINECRAFT_SERVER_MIN_RAM = var.minecraft_server_ram.min,
    MINECRAFT_SERVER_MAX_RAM = var.minecraft_server_ram.max,
  })
}

//Add SSH keys to the server
resource "digitalocean_ssh_key" "ssh_keys" {
  count = length(var.droplet_ssh_keys)
  name = "${var.droplet_name}-ssh-key-${count.index}"
  public_key = var.droplet_ssh_keys[count.index]
}

//Create a firewall that only allows inbound connections on the Minecraft server and SSH ports
resource "digitalocean_firewall" "server" {
  name = var.firewall_name
  tags = var.common_tags
  droplet_ids = [digitalocean_droplet.server.id]

  //SSH Management
  inbound_rule {
    protocol = "tcp"
    port_range = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  //Minecraft Java Server
  inbound_rule {
    protocol = "tcp"
    port_range = "25565"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  //Allow DNS lookups
  outbound_rule {
    protocol = "udp"
    port_range = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  
  //Make outbound HTTPS requests (software downloads)
  outbound_rule {
    protocol = "tcp"
    port_range = "80"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  
  //Make outbound HTTP requests (software downloads - e.g. apt-get)
  outbound_rule {
    protocol = "tcp"
    port_range = "443"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}