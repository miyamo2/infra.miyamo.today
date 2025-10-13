resource "helm_release" "this" {
  name       = "cockroachdb"
  chart      = "cockroachdb"
  repository = "https://charts.cockroachdb.com/"

  # see: https://github.com/cockroachdb/helm-charts/blob/master/cockroachdb/README.md#configuration
  set {
    name  = "image.tag"
    value = "v25.3.2"
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
    name  = "storage.persistentVolume.size"
    value = "10Gi"
  }

  set {
    name  = "tls.enabled"
    value = "false"
  }
  wait = false
}

resource "terraform_data" "client_secure" {
  provisioner "local-exec" {
    command = <<EOF
      kubectl create client-secure.yaml
    EOF
  }
}