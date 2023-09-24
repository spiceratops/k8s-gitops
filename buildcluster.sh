talosctl -n "192.168.10.201" apply-config --file ./talos/clusterconfig/k8s-k8s-cp01.yaml --insecure
sleep 180

talosctl -n "192.168.10.201" bootstrap
sleep 180

talosctl -n "192.168.10.202" apply-config --file ./talos/clusterconfig/k8s-k8s-cp02.yaml --insecure
sleep 180
talosctl -n "192.168.10.203" apply-config --file ./talos/clusterconfig/k8s-k8s-cp03.yaml --insecure
sleep 180
talosctl -n "192.168.10.211" apply-config --file ./talos/clusterconfig/k8s-k8s-wk01.yaml --insecure
sleep 180
talosctl -n "192.168.10.212" apply-config --file ./talos/clusterconfig/k8s-k8s-wk02.yaml --insecure
sleep 180
talosctl -n "192.168.10.213" apply-config --file ./talos/clusterconfig/k8s-k8s-wk03.yaml --insecure
sleep 300

kubectl kustomize --enable-helm ./talos/cni | kubectl apply -f -
kubectl kustomize --enable-helm ./talos/kubelet-csr-approver | kubectl apply -f -
sleep 300

kubectl apply --server-side --kustomize ./kubernetes/bootstrap/flux
sleep 60

sops --decrypt kubernetes/bootstrap/flux/age-key.sops.yaml | kubectl apply -f -
sops --decrypt kubernetes/bootstrap/flux/github-deploy-key.sops.yaml | kubectl apply -f -
sops --decrypt kubernetes/flux/vars/cluster-secrets.sops.yaml | kubectl apply -f -
kubectl apply -f kubernetes/flux/vars/cluster-settings.yaml
## Kube-prometheus-stack CRDs to speed up new cluster app deployment
kubectl apply -f https://raw.githubusercontent.com/prometheus-community/helm-charts/main/charts/kube-prometheus-stack/charts/crds/crds/crd-servicemonitors.yaml
kubectl apply --server-side --kustomize ./kubernetes/flux/config
