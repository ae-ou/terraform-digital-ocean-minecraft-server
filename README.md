# terraform-digital-ocean-minecraft-server
This module creates the infrastructure for running a Java Minecraft server on Digital Ocean.
To be specific, it creates:
- A VPC
- A Droplet (server)
    - The userdata template sets up OpenJDK and installs the Minecraft Server
- An SSH key resource
    - This grants a specified list of SSH keys access to the Droplet
- A firewall
    - Inbound traffic is allowed for SSH and traffic over TCP on port 25565 (the default port for the Java Minecraft server)
    - Outbound traffic is allowed over HTTP and HTTPS to allow for software installs/updates
    
## Requirements
- Terraform 0.13
- A Digital Ocean account with an API token exported to your env (using `export DIGITALOCEAN_TOKEN=<DIGITAL_OCEAN_TOKEN>`)
    
## Variables
| Name                           | Description                                                                                                                                                                                                                 | Required | Default Value                                                                              |
|--------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|--------------------------------------------------------------------------------------------|
| region                         | The region to create the infrastructure in                                                                                                                                                                                  | Yes      |                                                                                            |
| vpc_name                       | The name of the VPC to create for the Minecraft server                                                                                                                                                                      | Yes      |                                                                                            |
| droplet_name                   | The name to assign to the Droplet hosting the Minecraft Server                                                                                                                                                              | Yes      |                                                                                            |
| firewall_name                  | The name to assign to the firewall sitting in front of the Droplet hosting the Minecraft server                                                                                                                             | Yes      |                                                                                            |
| common_tags                    | Common tags to assign to supporting resources                                                                                                                                                                               | No       | []                                                                                         |
| droplet_size                   | The size of the Droplet to create (i.e. CPU and RAM allocations). Exhaustive list here: https://developers.digitalocean.com/documentation/v2/#list-all-sizes.                                                               | Yes      |                                                                                            |
| droplet_image                  | The OS image to use on the server. Defaults to Ubuntu 20.04. Will cause issues with the user data if you use an image that doesn't support apt. You can run `doctl compute image list-distribution --public` to get a list. | Yes      |                                                                                            |
| minecraft_server_download_path | The URL pointing to the Minecraft server image to install and run                                                                                                                                                           | Yes      | https://launcher.mojang.com/v1/objects/a412fd69db1f81db3f511c1463fd304675244077/server.jar |
| minecraft_server_ram           | The min/max RAM to allocate to the JVM running the Minecraft server                                                                                                                                                         | Yes      | {min = "1G", max = "1G"}                                                                   |
| droplet_ssh_keys               | List of SSH keys that can access the Droplet                                                                                                                                                                                | No       | []                                                                                         |

## Example
This can be called directly, or invoked as a module.

If you're invoking this directly, create a `terraform.tfvars` file within the route of this project, and add variables 
to that file in the following format (their values may be different depending on your use case):

```hcl-terraform
region = "lon1"
vpc_name = "minecraft-server-vpc"
droplet_name = "minecraft-server-droplet"
firewall_name = "minecraft-server-firewall"
common_tags = ["MinecraftServerLon1"]
droplet_size = "s-2vcpu-2gb"
droplet_image = "ubuntu-20-04-x64"
minecraft_server_download_path = "https://launcher.mojang.com/v1/objects/a412fd69db1f81db3f511c1463fd304675244077/server.jar"
minecraft_server_ram = {
  min = "1G",
  max = "1G"
}
droplet_ssh_keys = []
```

If you're using this as a module in a larger infrastructure definition, you can do the following:

```hcl-terraform
module "minecraft_digital_ocean" {
    source = "https://github.com/ae-ou/terraform-digital-ocean-minecraft-server"
    
    region = "lon1"
    vpc_name = "minecraft-server-vpc"
    droplet_name = "minecraft-server-droplet"
    firewall_name = "minecraft-server-firewall"
    common_tags = ["MinecraftServerLon1"]
    droplet_size = "s-2vcpu-2gb"
    droplet_image = "ubuntu-20-04-x64"
    minecraft_server_download_path = "https://launcher.mojang.com/v1/objects/a412fd69db1f81db3f511c1463fd304675244077/server.jar"
    minecraft_server_ram = {
      min = "1G",
      max = "1G"
    }
    droplet_ssh_keys = []
}
```