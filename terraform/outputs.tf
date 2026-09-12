output "node_public_ip" {
  value       = hcloud_server.node.ipv4_address
  description = "Public IP of the k3s node — use this for SSH and DNS"
}

output "node_private_ip" {
  value       = one(hcloud_server.node.network[*].ip)
  description = "Private network IP of the k3s node"
}
