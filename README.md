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

Talos Linux Image Factory
============

Needed system extensions:

 ```customization:
    systemExtensions:
        officialExtensions:
            - siderolabs/btrfs
            - siderolabs/i915
            - siderolabs/intel-ucode
            - siderolabs/iscsi-tools
            - siderolabs/qemu-guest-agent
 ```

Talos commands
============

Generate Machine Configurations (specifying disk with --install-disk)
```bash
talosctl gen config --install-disk "/dev/vda" talos-proxmox-cluster https://$CONTROL_PLANE_IP:6443 --output-dir _out --install-image  factory.talos.dev/nocloud-installer/77cbaa210db80862d6a2bbbe8c22379dbde2ced240124ed6e25a68a5074f0d24:v1.11.0 --config-patch @patch.yaml
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

Cilium installation
============

Cillium without kube-proxy but with Gateway API support

```cilium install \
    --set ipam.mode=kubernetes \
    --set kubeProxyReplacement=true \
    --set securityContext.capabilities.ciliumAgent="{CHOWN,KILL,NET_ADMIN,NET_RAW,IPC_LOCK,SYS_ADMIN,SYS_RESOURCE,DAC_OVERRIDE,FOWNER,SETGID,SETUID}" \
    --set securityContext.capabilities.cleanCiliumState="{NET_ADMIN,SYS_ADMIN,SYS_RESOURCE}" \
    --set cgroup.autoMount.enabled=false \
    --set cgroup.hostRoot=/sys/fs/cgroup \
    --set k8sServiceHost=localhost \
    --set k8sServicePort=7445 \
    --set gatewayAPI.enabled=true \
    --set gatewayAPI.enableAlpn=true \
    --set gatewayAPI.enableAppProtocol=true
```
