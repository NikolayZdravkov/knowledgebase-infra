resource "helm_release" "traefik" {
    name             = "traefik"
    repository       = "https://helm.traefik.io/traefik"
    chart            = "traefik"
    version          = "32.1.1"
    namespace        = "ingress-system"
    create_namespace = true  

    values = [file("${path.module}/../k8s/platform/traefik/values.yaml")]
}