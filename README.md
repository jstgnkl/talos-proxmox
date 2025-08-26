Talos Proxmox
=================

### Built With:

* [Talos Linux](https://talos.dev)
* [Proxmox Terraform Provider](https://registry.terraform.io/providers/Telmate/proxmox/latest)

Prerequisites
============


* talosctl CLI:
 ```bash
 curl -sL https://talos.dev/install | sh
 ```
 * [kubectl](https://kubernetes.io/docs/tasks/tools/)
 * [terraform](https://developer.hashicorp.com/terraform/downloads?product_intent=terraform)


Talos commands
============

Generate Machine Configurations (specifying disk with --install-disk)
```bash
talosctl gen config --install-disk "/dev/vda" talos-proxmox-cluster https://$CONTROL_PLANE_IP:6443 --output-dir _out --install-image factory.talos.dev/installer/ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515:v1.10.6
```

Create Control Plane Node
```bash
talosctl apply-config --insecure --nodes $CONTROL_PLANE_IP --file _out/controlplane.yaml
```

Create Worker Node
```bash
talosctl apply-config --insecure --nodes $WORKER_IP --file _out/worker.yaml
```

Using the Cluster
```bash
export TALOSCONFIG="_out/talosconfig"
talosctl config endpoint $CONTROL_PLANE_IP
talosctl config node $CONTROL_PLANE_IP
```

Bootstrap Etcd
```bash
talosctl bootstrap
```

Retrieve the kubeconfig
```bash
talosctl kubeconfig .
```