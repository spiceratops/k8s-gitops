<div align="center">

### Yet another over-the-top homelab k8s cluster ☸

_... automated via [Flux](https://fluxcd.io), [Renovate](https://github.com/renovatebot/renovate) and [GitHub Actions](https://github.com/features/actions)_ 🤖

</div>

---

## 📖 Overview

This is a mono repository for my home infrastructure and Kubernetes cluster. It is deployed and managed using tools like [Talos](https://talos.dev/), [Kubernetes](https://kubernetes.io/), [Flux](https://github.com/fluxcd/flux2), [Terraform](https://www.terraform.io/), [Renovate](https://github.com/renovatebot/renovate) and [GitHub Actions](https://github.com/features/actions).

---

## ⛵ Kubernetes

There is a template over at [onedr0p/flux-cluster-template](https://github.com/onedr0p/flux-cluster-template) if you wanted to try and follow along with some of the practices I use here.

### Installation

This semi hyper-converged cluster runs [Talos Linux](https://talos.dev), an immutable and ephemeral Linux distribution built for [Kubernetes](https://k8s.io), deployed on [Proxmox](https://www.proxmox.com/). [Rook](https://rook.io) then provides my workloads with persistent block, object, and file storage; while a seperate server running TrueNAS provides file storage for my media.

🔸 _[Click here](./talos/talconfig.yaml) to see my Talos configuration._

### Core Components

- [actions-runner-controller](https://github.com/actions/actions-runner-controller): Self-hosted Github runners.
- [cilium](https://cilium.io): Internal Kubernetes networking plugin.
- [cert-manager](https://cert-manager.io): Creates SSL certificates for services in my Kubernetes cluster.
- [external-dns](https://github.com/kubernetes-sigs/external-dns): Automatically manages DNS records from my cluster in a cloud DNS provider.
- [external-secrets](https://external-secrets.io): Managed Kubernetes secrets using [1Password Connect](https://github.com/1Password/connect).
- [ingress-nginx](https://github.com/kubernetes/ingress-nginx): Ingress controller for Kubernetes using NGINX as a reverse proxy and load balancer.
- [rook](https://rook.io): Distributed block storage for peristent storage.
- [sops](https://github.com/getsops/sops): Managed secrets for Kubernetes and Terraform which are commited to Git.
- [tf-controller](https://github.com/weaveworks/tf-controller): additional Flux component used to run Terraform from within a Kubernetes cluster.
- [volsync](https://github.com/backube/volsync) and [snapscheduler](https://github.com/backube/snapscheduler): Backup and recovery of persistent volume claims.

### GitOps

[Flux](https://github.com/fluxcd/flux2) watches my [kubernetes](./kubernetes/) folder (see Directories below) and makes the changes to my cluster based on the YAML manifests.

The way Flux works for me here is it will recursively search the [kubernetes/apps](./kubernetes/apps) folder until it finds the most top level `kustomization.yaml` per directory and then apply all the resources listed in it. That aforementioned `kustomization.yaml` will generally only have a namespace resource and one or many Flux kustomizations. Those Flux kustomizations will generally have a `HelmRelease` or other resources related to the application underneath it which will be applied.

[Renovate](https://github.com/renovatebot/renovate) watches my **entire** repository looking for dependency updates, when they are found a PR is automatically created. When some PRs are merged [Flux](https://github.com/fluxcd/flux2) applies the changes to my cluster.

### Directories

This Git repository contains the following directories under [kubernetes](./kubernetes/).

```sh
📁 kubernetes      # Kubernetes cluster defined as code
├─📁 bootstrap     # Flux installation
├─📁 flux          # Main Flux configuration of repository
└─📁 apps          # Apps deployed into my cluster grouped by namespace (see below)
```

### Cluster layout

Below is a a high level look at the layout of how my directory structure with Flux works. In this brief example you are able to see that `authelia` will not be able to run until `lldap` and `cloudnative-pg` are running. It also shows that the `Cluster` custom resource depends on the `cloudnative-pg` Helm chart. This is needed because `cloudnative-pg` installs the `Cluster` custom resource definition in the Helm chart.

### Networking

| Name                         | CIDR              |
|------------------------------|-------------------|
| Kubernetes nodes             | `192.168.1.0/24`     |
| Kubernetes pods              | `10.244.0.0/16`   |
| Kubernetes services          | `10.245.0.0/16`   |
| Kubernetes external services | `192.168.15.0/24` |

- [cilium](https://github.com/cilium/cilium) is configured with the `io.cilium/lb-ipam-ips` annotation to expose Kubernetes services with their own IP over L3 (BGP), which is configured on my router. L2 (ARP) can also be announced in addition to L3 via the `io.cilium/lb-ipam-layer2` label.
- [cloudflared](https://github.com/cloudflare/cloudflared) provides a [secure tunnel](https://www.cloudflare.com/products/tunnel) for [Cloudflare](https://www.cloudflare.com) to ingress into [ingress-nginx](https://github.com/kubernetes/ingress-nginx), my ingress controller.

🔸 _[Click here](./kubernetes/apps/networking/cloudflared/app/configs/config.yaml) to see my `cloudflared` configuration._

---

## 🌐 DNS

### Internal DNS

Opnsense resolves DNS queries via [Adguardhome](https://github.com/0xERR0R/blocky) that then goes to upstream Unifi DNS on my UDM.

### External DNS

[external-dns](https://github.com/kubernetes-sigs/external-dns) is deployed in my cluster and configured to sync DNS records to [Cloudflare](https://www.cloudflare.com/) using ingresses `external-dns.alpha.kubernetes.io/target` annotation.

External-DNS is also used to sync internal records to Adguardhome and Unifi DNS

---

## ⭐ Stargazers

<div align="center">

[![Star History Chart](https://api.star-history.com/svg?repos=spiceratops/k8s-gitops&type=Date)](https://star-history.com/#spiceratops/k8s-gitops&Date)

</div>

---

## 🤝 Gratitude and Thanks

Thanks to the usual @home-operation champions such as @buroa for the initial repo structure idea, @onedr0p for various yoinks, @bjw-s for the amazing cluster-template.

Thanks to all the people who donate their time to the [Home Operations](https://discord.gg/home-operations) Discord community. A lot of inspiration for my cluster comes from the people that have shared their clusters using the [k8s-at-home](https://github.com/topics/k8s-at-home) GitHub topic. Be sure to check out the [Kubernetes @Home search](https://nanne.dev/k8s-at-home-search) for ideas on how to deploy applications or get ideas on what you can deploy.

---

## 🔏 License

See [LICENSE](./LICENSE)
