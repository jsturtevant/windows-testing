# gmsa-webhook Extension

This extension will deploy the gmsa webhook as an Adminision Controller onto the cluster with a a SSL certificate signed by k8s.  This is required for gmsa tests to pass at https://github.com/kubernetes/kubernetes/blob/master/test/e2e/windows/gmsa_full.go. Find more details at https://github.com/kubernetes-sigs/windows-gmsa/.

This extension will deploy the webhook on the linux nodes.

# Configuration

|Name               |Required|Acceptable Value     |
|-------------------|--------|---------------------|
|name               |yes     |gmsa-webhook         |
|version            |yes     |v1                   |
|rootURL            |optional|                     |

# Example

```
    ...
    "masterProfile": {
      "count": 1,
      "dnsPrefix": "",
      "vmSize": "Standard_D2_v3",
      "distro": "ubuntu",
      "extensions": [
          {
              "name": "master_extension"
          },
          {
              "name": "gmsa-webhook"
          }
      ]
    },
    ...
    "extensionProfiles": [
        {
          "name":                "gmsa-webhook",
          "version":             "v1",
          "extensionParameters": "parameters",
          "rootURL":             "https://raw.githubusercontent.com/kubernetes-sigs/windows-testing/master/",
          "script":              "install-gmsa-webhook.sh"
        }
    ]
    ...
```


# Supported Orchestrators

Kubernetes

# Troubleshoot

Extension execution output is logged to files found under the following directory on the target virtual machine.

```
/var/log/azure/install-gmsa-webhook.log
```
