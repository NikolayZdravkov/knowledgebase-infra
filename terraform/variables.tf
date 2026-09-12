variable "hcloud_token" {
  sensitive   = true
  description = "Hetzner Cloud API token"
}

variable "ssh_public_key_path" {
  default = "~/.ssh/mlops_key.pub"
}

variable "location" {
  type        = string
  default     = "hel1"
  description = "Hetzner location for all resources"
}

variable "server_type" {
  type        = string
  default     = "cx33"
  description = "Hetzner server type for the k3s node"
}
