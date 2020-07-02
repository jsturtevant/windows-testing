#!/bin/bash

echo "start master extension" >> /tmp/master_extension.log

KUBECONFIG="$(find /home/*/.kube/config)"
KUBECTL="kubectl --kubeconfig=${KUBECONFIG}"

# Wait for coredns pod to be ready
while true; do
	COREDNS_READY=$(${KUBECTL} get pods -l k8s-app=kube-dns -n kube-system -o custom-columns=STATUS:status.containerStatuses[0].ready --no-headers)
	if [ "${COREDNS_READY}" = "true" ]; then
		echo "$(date -R) - coredns is ready" >> /tmp/master_extension.log
		${KUBECTL} get pods --all-namespaces >> /tmp/master_extension.log
		break
	fi
	sleep 2
done

# Wait for all pods in kube-system namespace to be ready before applying taints
while true; do
	NOTREADY_PODS=$(${KUBECTL} get pods -n kube-system -o custom-columns=STATUS:status.containerStatuses[0].ready --no-headers | grep -v "true")
	if [ -z "${NOTREADY_PODS}" ]; then
		echo "$(date -R) - All kube-system pods are ready" >> /tmp/master_extension.log
		${KUBECTL} get pods --all-namespaces >> /tmp/master_extension.log
		break
	fi
	sleep 2
done

master_node=$(${KUBECTL} get nodes | grep master | awk '{print $1}')

${KUBECTL} taint nodes "$master_node" node-role.kubernetes.io/master=:NoSchedule
${KUBECTL} label nodes "$master_node" node-role.kubernetes.io/master=NoSchedule

echo "finish master extension" >> /tmp/master_extension.log
