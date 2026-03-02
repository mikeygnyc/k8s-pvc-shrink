# Kube-PVC-Shrink 🚀

A high-integrity CLI tool for shrinking Kubernetes Persistent Volume Claims (PVCs). This tool uses a "Double-Hop" copy staging method to ensure data safety. While this tool can be used to resize a PVC in either direction it is designed to shrink a PVC as generally enlarging a PVC can be done online.

## ⚡️ Instant Installation
Run this one-liner to automatically detect your PATH (Homebrew or /usr/local/bin) and install the latest version:

```bash
curl -fsSL https://raw.githubusercontent.com/mikeygnyc/k8s-pvc-shrink/main/install.sh | bash"
```

## ✨ Key Features
* **Interactive UI**: Uses `fzf` to let you visually pick your Deployment, StatefulSet, and PVC.
* **In-Place Updates**: Automatically detects and installs newer versions from GitHub, then restarts the session seamlessly.
* **Safety Rollback**: If a data sync fails, the script automatically scales your resources back up to their original state.
* **Data Verification**: Generates a side-by-side table comparing **File Count** and **Disk Usage (du)**.
* **SMB Optimized**: Uses `rsync` flags that prevent permission/ownership errors.
* **Audit Logging**: Detailed logs of every file moved are saved to `./migration_logs`.

## 🛠 Prerequisites
Ensure these are installed on your machine:
* `kubectl` (Configured for your cluster)
* `fzf` (Interactive filtering)
* `yq` (YAML processing)
* `column` (Standard on Linux/macOS)

## 📖 Usage
Once installed, simply run:
```bash
kubectl pvc-shrink
```

### Optional Flags:
* `--version`: Check installed version.
* `--no-check`: Skip the version check on startup.
* `--dry-run`: Preview the `yq` YAML transformations without making any changes.

## 🏗 Development & Releasing
This project uses GitHub Actions to manage versions. To release a new version:
1. Push your changes to `main`.
2. Create and push a new git tag:
   ```bash
   git tag v1.x.x
   git push origin --tags

## 🛡 License
This project is licensed under the **MIT License**.