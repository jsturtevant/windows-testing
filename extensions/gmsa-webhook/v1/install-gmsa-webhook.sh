#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

tempFolder=$(mktemp -d -t "gmsa-install")
curl -L -o $tempFolder/deploy-gmsa-webhook.sh https://raw.githubusercontent.com/kubernetes-sigs/windows-gmsa/master/admission-webhook/deploy/deploy-gmsa-webhook.sh 

export KUBECONFIG="$(find /home/*/.kube/config)"
$tempFolder/deploy-gmsa-webhook.sh --file "$tempFolder/manifests.yml" \
	--name "gmsa-webhook" \
	--namespace "gmsa-webhook" \
	--certs-dir "$tempFolder/certs" \
	--tolerate-master

