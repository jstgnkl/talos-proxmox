locals {
  talos_nodes = {
    "talos-control-01" = {}
    "talos-control-02" = {}
    "talos-control-03" = {}
    "talos-worker-01"  = {}
    "talos-worker-02"  = {}
    "talos-worker-03"  = {}
  }
  
  talos_node_names = keys(local.talos_nodes)
  ip_assignments = {
    "talos-control-01" = "10.0.0.81"
    "talos-control-02" = "10.0.0.82"
    "talos-control-03" = "10.0.0.83"
    "talos-worker-01"  = "10.0.0.91"
    "talos-worker-02"  = "10.0.0.92"
    "talos-worker-03"  = "10.0.0.93"
  }
}

resource "proxmox_vm_qemu" "talos" {
  for_each    = local.talos_nodes
  vmid        = 500 + index(local.talos_node_names, each.key)
  agent       = 1
  boot        = "order=virtio0;ide2;net0"
  memory      = 4096
  name        = each.key
  scsihw      = "virtio-scsi-single"
  target_node = "pve"

  disks {
    ide {
      ide0 {
        cloudinit {
          storage = "local-lvm"
        }
      }
      ide2 {
        cdrom {
          iso = "DSM:iso/nocloud-amd64.iso"
        }
      }
    }

    virtio {
      virtio0 {
        disk {
          size    = "64G"
          storage = "local-lvm"
        }
      }
    }
  }

  network {
    bridge = "vmbr0"
    id     = 0
    model  = "virtio"
  }

  ipconfig0    = "ip=${local.ip_assignments[each.key]}/24,gw=10.0.0.1"
  nameserver   = "10.0.0.250"
  searchdomain = "zenety.nl"

  cpu {
    cores = 2
    type = "host"
  }
}
