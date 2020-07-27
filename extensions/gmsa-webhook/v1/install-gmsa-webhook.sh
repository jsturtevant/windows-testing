#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

gmsaInstallFile="https://raw.githubusercontent.com/kubernetes-sigs/windows-gmsa/master/admission-webhook/deploy/deploy-gmsa-webhook.sh"

echo "$(date -R): getting latest gmsa install file: $gmsaInstallFile"
tempFolder=$(mktemp -d -t "gmsa-installXXXX") 
curl -L -o $tempFolder/deploy-gmsa-webhook.sh $gmsaInstallFile
chmod +x $tempFolder/deploy-gmsa-webhook.sh

echo "$(date -R): running installer"
export KUBECONFIG="$(find /home/*/.kube/config)"
$tempFolder/deploy-gmsa-webhook.sh --file "$tempFolder/manifests.yml" \
	--name "gmsa-webhook" \
	--namespace "gmsa-webhook" \
	--certs-dir "$tempFolder/certs" \
	--tolerate-master
echo "$(date -R): gmsa installed"
