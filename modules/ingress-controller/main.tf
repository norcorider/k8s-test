resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = var.ingress_namespace
  }
}

resource "helm_release" "ingress_nginx" {
  namespace  = var.ingress_namespace
  name       = var.ingress_name
  chart      = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"


  set {
      name  = "defaultBackend.nodeSelector\\.beta\\.kubernetes\\.io/os"
      value = "linux"
  }
  set {
      name  = "controller.nodeSelector\\.beta\\.kubernetes\\.io/os"
      value = "linux"
  }
  set {
      name  = "controller.admissionWebhooks.patch.nodeSelector\\.beta\\.kubernetes\\.io/os"
      value = "linux"
  }
  set {
      name  = "controller.replicaCount"
      value = 2
  }
  set {
      name  = "controller.service.externalTrafficPolicy"
      value = "Local"
  }
  set {
      name  = "controller.service.loadBalancerIP"
      value = var.ingress_ip_address
  }
  set {
      name  = "controller.ingressClass"
      value = var.ingress_controller_class
  }
}

