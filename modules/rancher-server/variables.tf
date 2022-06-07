variable "cert_manager" {
  type = object({
    ns = string
    version = string
    chart_set = list(object({
      name = string
      value = string
    }))
  })
  default = {
    ns = "cert-manager"
    version = "v1.7.0"
    chart_set = [
      {
        name = "installCRDs"
        value = "true"
      }
    ]
  }
  description = "Cert-manager helm chart properties. Chart sets can be added using chart_set param"
}

variable "rancher_server" {
  type = object({
    ns = string
    version = string
    branch = string
    chart_set = list(object({
      name = string
      value = string
    }))
  })
  default = {
    ns = "cattle-system"
    version = "v2.6.3"
    branch = "latest"
    chart_set = [
      {
        name = "bootsrapPassword"
        value = "Password!123@"
      }
    ]
  }
  description = "Rancher server helm chart properties. Chart sets can be added using chart_set param"
}

variable "rancher_hostname" {
  type = string
  description = "Rancher server hostname to set on deployment"
}

variable "rancher_replicas" {
  type = number
  description = "Rancher server replicas to set on deployment"
  default = 3
}

variable "rancher_k8s" {
  type = object({
    host = string
    client_certificate = string
    client_key = string
    cluster_ca_certificate = string
  })
  description = "K8s cluster client configuration"
}