terraform {
  cloud {
    organization = "spiceratops"
    workspaces {
      name = "terraform-cloudflare"
    }
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.7.1"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.5.0"
    }
  }

  required_version = ">= 1.3.0"
}

module "onepassword_item" {
  source = "github.com/bjw-s/terraform-1password-item?ref=main"
  vault  = "K8s"
  item   = "cloudflare"
}

data "http" "ipv4_lookup_raw" {
  url = "http://ipv4.icanhazip.com"
}

data "cloudflare_zone" "domain" {
  name = "ktwo.io"
}
