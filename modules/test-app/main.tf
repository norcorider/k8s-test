resource "kubernetes_namespace" "test" {
  metadata {
    name = "${var.namespace}"
  }
}

resource "helm_release" "app" {
  namespace  = "${var.namespace}"
  name       = "${var.name}"
  chart      = "${path.root}/helm/app"
  version    = "0.0.1"

  set {
    name  = "name"
    value = "test"
  }
  set {
    name  = "registry"
    value = "nginxdemos"
  }
  set {
    name  = "image"
    value = "nginx-hello"
  }
  set {
    name  = "tag"
    value = "plain-text"
  }
  set {
    name  = "containerPort"
    value = 80
  }
  set {
    name  = "replicas"
    value = 3
  }

  depends_on = [
      kubernetes_namespace.test
  ]
}
