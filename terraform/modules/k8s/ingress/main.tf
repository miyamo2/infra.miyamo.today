resource "helm_release" "this" {
  name             = "nginx-ingress"
  chart            = "nginx-ingress"
  namespace        = "ingress"
  create_namespace = true
  repository       = "https://helm.nginx.com/stable"
  timeout          = 500

  # see: https://docs.nginx.com/nginx-ingress-controller/installation/installing-nic/installation-with-helm/#configuration
  set {
    name  = "controller.kind"
    value = "daemonset"
  }

  set {
    name  = "controller.resources.requests.cpu"
    value = "0"
  }

  set {
    name  = "controller.resources.requests.memory"
    value = "0"
  }

  set {
    name  = "controller.service.type"
    value = "NodePort"
  }

  set {
    name  = "controller.service.httpPort.nodePort"
    value = "30080"
  }

  set {
    name  = "controller.service.httpsPort.enable"
    value = "false"
  }
}