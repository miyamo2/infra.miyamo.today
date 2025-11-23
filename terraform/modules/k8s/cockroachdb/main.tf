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
    value = "500m"
  }

  set {
    name  = "statefulset.resources.requests.memory"
    value = "768Mi"
  }

  set {
    name  = "statefulset.resources.limits.cpu"
    value = "1000m"
  }

  set {
    name  = "statefulset.resources.limits.memory"
    value = "768Mi"
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
    name  = "conf.store.enabled"
    value = "true"
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

#resource "terraform_data" "patch_subdomain" {
#  triggers_replace = {
#    manifest   = helm_release.this.manifest
#    patch_file = filebase64("${path.module}/patch_subdomain.yaml")
#  }
#  provisioner "local-exec" {
#    command = <<EOF
#    kubectl --context ${var.kubeconfig_context} -n ${var.kubernetes_namespace} patch --type merge statefulset cockroachdb --patch-file ${path.module}/patch_subdomain.yaml
#    kubectl --context ${var.kubeconfig_context} -n ${var.kubernetes_namespace} rollout restart statefulset/cockroachdb
#    EOF
#  }
#}
