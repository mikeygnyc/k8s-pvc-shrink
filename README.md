# kubectl-pvcshrink

`kubectl-pvcshrink` is a kubectl plugin for safely shrinking Persistent Volume Claims (PVCs) in Kubernetes. Since Kubernetes does not natively support shrinking volumes, this tool automates the complex workflow of scaling workloads, migrating data via `rsync`, and verifying integrity.

## ⚡️ Installation
Run this one-liner to install the kubectl plugin. It automatically detects your PATH (Homebrew or /usr/local/bin) and installs the latest version:

```bash
curl -fsSLH "Cache-Control: no-cache" https://raw.githubusercontent.com/mikeygnyc/k8s-pvc-shrink/refs/heads/main/install.sh | bash
```

## ✨ Features

* **Intelligent Sizing:** Automatically calculates current data usage and prevents shrinking below the actual data size.
* **Safety Thresholds:** Warns if the new size leaves less than 10% overhead for application stability.
* **Real-time Progress:** Uses `kubectl exec` to provide a live, unbuffered `rsync` progress bar.
* **Deep Metadata Cleaning:** Strips CSI-specific annotations (like `pv.kubernetes.io/bind-completed`) to prevent "Lost" PVC status during recreation.
* **Resource Scaling:** Automatically scales Deployments or StatefulSets to 0 and back up, with live rollout tracking via `kubectl rollout status`.
* **CNPG Instance Shrink:** Supports CloudNativePG (CNPG) clusters by promoting a new primary if needed, fencing the target instance, shrinking its PVC, then unfencing it.
* **Data Verification:** Performs checksum-style file count and size matching after every sync.

## 📋 Prerequisites

The following tools must be installed on your local machine:

* `kubectl`: Connected to your cluster.
* `fzf`: For interactive resource selection.
* `yq` (v4+): For YAML processing.
* `bc` & `numfmt`: For precise storage mathematics.
* `curl` & `column`: For updates and formatting.
* `kubectl cnpg` plugin: Required only for CNPG workflows.

## 🚀 Usage

Primary (kubectl plugin):
`kubectl pvcshrink`

Standalone (optional):
`./kubectl-pvcshrink`

Dry-run mode (shows generated YAML):
`kubectl pvcshrink --dry-run`

Skip the automatic update check:
`kubectl pvcshrink --no-check`

## 🔄 The Workflow

1. **Selection:** Choose between `Deployment`, `StatefulSet`, or `CNPG` via an interactive menu (only types that exist in the cluster are shown).
2. **Safety Check:** The script calculates actual data usage on the live pod using `du`.
3. **Input:** Enter the new size. If you omit the unit (e.g., `50`), the script automatically appends the current unit (e.g., `Gi`).
4. **Scaling:** Workload is scaled to 0 to ensure data consistency (CNPG uses fencing on the target instance).
5. **Migration 1:** Data is synced from the original PVC to a temporary "staging" PVC.
6. **Recreation:** The original PVC is deleted and recreated at the new, smaller size.
7. **Migration 2:** Data is synced back from staging to the new, smaller PVC.
8. **Restore:** Workload is scaled back up to its original replica count.



## 🛠 Troubleshooting

### "Lost" PVC Status
If your PVC enters a `Lost` state, it is usually because the CSI driver is trying to bind to a stale Volume ID. This script mitigates this by "Deep Cleaning" the PVC manifest, but ensure your `StorageClass` supports dynamic provisioning.

### Sync Performance
The script uses the `instrumentisto/rsync-ssh` image. If you are in an air-gapped environment, you can change the `RSYNC_IMAGE` constant at the top of the script to point to your internal registry.

## 🛡 Security
* The script requires `exec` permissions on pods to calculate disk usage and perform the sync.
* All data remains within your cluster; `rsync` happens pod-to-pod via the cluster network.
