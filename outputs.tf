output "vpc_id" {
  description = "The ID of the VPC that the resources reside in."
  value = digitalocean_vpc.vpc.id
}

output "server_id" {
  description = "The ID of the server"
  value = digitalocean_droplet.server.id
}

output "server_public_ipv4" {
  description = "The public ipv4 address for the server"
  value = digitalocean_droplet.server.ipv4_address
}

output "server_firewall_id" {
  description = "The ID of the firewall associated with the server"
  value = digitalocean_firewall.server.id
}