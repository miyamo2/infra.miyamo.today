resource "helm_release" "this" {
  name             = "cockroachdb"
  chart            = "cockroachdb"
  repository       = "https://charts.cockroachdb.com/"
  timeout          = 1000

  # see: https://github.com/cockroachdb/helm-charts/blob/master/cockroachdb/README.md#configuration
  set {
    name  = "statefulset.resources.requests.cpu"
    value = "100m"
  }

  set {
    name  = "statefulset.resources.requests.memory"
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
}

resource "terraform_data" "namespace" {
  triggers_replace = {
    "config_context" = var.config_context
  }
  provisioner "local-exec" {
    command = <<EOF
      kubectl exec -it cockroachdb-client-secure -- ./cockroach sql --certs-dir=/cockroach/cockroach-certs --host=cockroachdb-public --insecure
      CREATE USER goose_user WITH MODIFYCLUSTERSETTING;
      CREATE USER ${var.sql_user_name};
      CREATE DATABASE IF NOT EXISTS article;
      CREATE DATABASE IF NOT EXISTS tag;
    EOF
  }
}