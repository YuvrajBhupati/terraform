## Trivy & jq

Trivy is used for vulnerability, misconfiguration, secret, and license scanning.  
jq is required for parsing Trivy JSON output locally.

### Installation

#### macOS (Homebrew)

```bash
brew install trivy jq
```

#### Linux (Debian/Ubuntu)

```bash
# Install Trivy
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh

# Install jq
sudo apt update
sudo apt install jq
```

#### Windows (Git Bash)

```bash
# Install Trivy
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh

# Install jq
mkdir -p /c/jq && \
curl -L -o /c/jq/jq.exe https://github.com/jqlang/jq/releases/latest/download/jq-windows-amd64.exe

# Add jq to PATH
export PATH=$PATH:/c/jq
```

---

### Verify Installation

```bash
trivy -v
jq --version
```

---

### Run Security Scan Locally

```bash
trivy fs --config trivy.yaml --format json -o trivy-results.json . && \
bash scripts/extract-trivy-summary.sh trivy-results.json && \
bash scripts/check-license-policy.sh trivy-results.json
```

---

### Output

```bash
cat /tmp/trivy-output
```
