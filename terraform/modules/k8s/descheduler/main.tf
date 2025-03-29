resource "helm_release" "this" {
  name       = "descheduler"
  chart      = "descheduler"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/descheduler/"
  timeout    = 500

  set {
    name  = "resources.requests.cpu"
    value = "0"
  }

  set {
    name  = "resources.requests.memory"
    value = "0"
  }

  set {
    name  = "schedule"
    value = "*/5 * * * *"
  }
}