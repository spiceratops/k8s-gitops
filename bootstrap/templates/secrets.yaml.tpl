---
apiVersion: v1
kind: Namespace
metadata:
  name: external-secrets
---
apiVersion: v1
kind: Secret
metadata:
  name: onepassword-secret
  namespace: external-secrets
stringData:
  1password-credentials.json: op://sc-secrets/1password/OP_CREDENTIALS_JSON
  token: op://sc-secrets/1password/OP_CONNECT_TOKEN
---
apiVersion: v1
kind: Namespace
metadata:
  name: flux-system
---
apiVersion: v1
kind: Secret
metadata:
  name: sops-age-secret
  namespace: flux-system
stringData:
  age.agekey: op://sc-secrets/sops/SOPS_PRIVATE_KEY
---
apiVersion: v1
kind: Secret
metadata:
  name: cluster-secrets
  namespace: flux-system
stringData:
  SECRET_DOMAIN: op://sc-secrets/domains/DOMAIN
  SECRET_DOMAIN_INTERNAL: op://sc-secrets/domains/DOMAIN_INTERNAL
  PRIVATE_DOMAIN: op://sc-secrets/domains/DOMAIN_INTERNAL
  PRIVATE_DOMAIN_HOME: op://sc-secrets/domains/DOMAIN_INTERNAL
  PRIVATE_EMAIL: sop://sc-secrets/domains/PRIVATE_EMAIL
  PUBLIC_DOMAIN: op://sc-secrets/domains/DOMAIN
  PUBLIC_IPV6_PREFIX: op://sc-secrets/public-prefix/PUBLIC_PREFIX
