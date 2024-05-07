
output "ssh_public_key" {
  description = "SSH Public Key"  
  value = tls_private_key.ssh_key.public_key_openssh
}