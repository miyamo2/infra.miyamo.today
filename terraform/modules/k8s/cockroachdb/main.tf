resource "helm_release" "this" {
  name       = "cockroachdb"
  chart      = "cockroachdb"
  namespace  = var.kubernetes_namespace
  repository = "https://charts.cockroachdb.com/"
  timeout    = 600
  wait       = false
  # see: https://github.com/cockroachdb/helm-charts/blob/master/cockroachdb/README.md#configuration
  set {
    name  = "image.tag"
    value = "v25.2.8"
  }

  set {
    name  = "statefulset.resources.requests.cpu"
    value = "100m"
  }

  set {
    name  = "statefulset.resources.requests.memory"
    value = "512Mi"
  }

  set {
    name  = "statefulset.resources.limits.cpu"
    value = "100m"
  }

  set {
    name  = "statefulset.resources.limits.memory"
    value = "512Mi"
  }

  set {
    name  = "conf.cache"
    value = "25%"
  }

  set {
    name  = "conf.max-sql-memory"
    value = "25%"
  }

  set {
    name  = "storage.persistentVolume.storageClass"
    value = "longhorn"
  }

  set {
    name  = "storage.persistentVolume.size"
    value = "10Gi"
  }

  set {
    name  = "tls.enabled"
    value = "false"
  }
}