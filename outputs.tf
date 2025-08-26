output "dhcp_ip" {
  value = { for k, v in proxmox_vm_qemu.talos : k => v.default_ipv4_address }
}