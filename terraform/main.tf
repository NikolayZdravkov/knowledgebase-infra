provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_ssh_key" "default" {
  name       = "homelab-key"
  public_key = file(var.ssh_public_key_path)
}

resource "hcloud_network" "homelab" {
  name     = "homelab-network"
  ip_range = "10.0.0.0/16"
}

resource "hcloud_network_subnet" "homelab" {
  network_id   = hcloud_network.homelab.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "10.0.1.0/24"
}

resource "hcloud_server" "node" {
  name        = "homelab-node"
  image       = "ubuntu-24.04"
  server_type = var.server_type
  location    = var.location
  ssh_keys    = [hcloud_ssh_key.default.id]

  network {
    network_id = hcloud_network.homelab.id
    ip         = "10.0.1.10"
  }
}

resource "hcloud_firewall" "homelab" {
  name = "homelab-firewall"

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "80"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "443"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "6443"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
}

resource "hcloud_firewall_attachment" "homelab" {
  firewall_id = hcloud_firewall.homelab.id
  server_ids  = [hcloud_server.node.id]
}
