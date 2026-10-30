  resource "helm_release" "cert_manager" {
    name             = "cert-manager"
    repository       = "https://charts.jetstack.io"
    chart            = "cert-manager"
    version          = "v1.16.2"
    namespace        = "cert-manager"
    create_namespace = true

    values = [file("${path.module}/../k8s/platform/cert-manager/values.yaml")]
  }