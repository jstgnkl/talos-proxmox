locals {
  talos_nodes = {
  "talos-control-01" = {}
  "talos-control-02" = {}
  "talos-control-03" = {}
  "talos-worker-01" = {}
  "talos-worker-02" = {}
  "talos-worker-03" = {}
  }
}

resource "proxmox_vm_qemu" "talos" {
 for_each    = local.talos_nodes
 agent       = 1
 boot        = "order=virtio0;ide2;net0"
 memory      = 4096
 name        = each.key
 scsihw      = "virtio-scsi-single"
 target_node = "pve"

 disks {
   ide {
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
    id    = 0
    model = "virtio"
  }

  cpu {
    cores = 2
  }
}