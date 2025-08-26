terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.2-rc04"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.9.0-alpha.0"
    }
  }
}