resource "helm_release" "this" {
  name             = "newrelic-bundle"
  chart            = "nri-bundle"
  namespace        = "newrelic"
  create_namespace = true
  repository       = "https://helm-charts.newrelic.com"
  timeout          = 500

  set {
    name  = "global.licenseKey"
    value = var.license_key
  }

  set {
    name  = "global.cluster"
    value = "blogapi-cluster"
  }

  set {
    name  = "global.lowDataMode"
    value = "true"
  }

  set {
    name  = "kube-state-metrics.image.tag"
    value = "v2.13.0"
  }

  set {
    name  = "kube-state-metrics.enabled"
    value = "true"
  }

  set {
    name  = "kubeEvents.enabled"
    value = "true"
  }

  set {
    name  = "newrelic-prometheus-agent.enabled"
    value = "true"
  }

  set {
    name  = "newrelic-prometheus-agent.lowDataMode"
    value = "true"
  }

  set {
    name  = "newrelic-prometheus-agent.config.kubernetes.integrations_filter.enabled"
    value = "false"
  }

  set {
    name  = "k8s-agents-operator.enabled"
    value = "true"
  }

  set {
    name  = "logging.enabled"
    value = "true"
  }

  set {
    name  = "newrelic-logging.lowDataMode"
    value = "false"
  }
}

resource "terraform_data" "this" {
  triggers_replace = {
    "config_context" = var.config_context
    "manifest"       = helm_release.this
  }
  provisioner "local-exec" {
    command = <<EOF
      kubectl apply -f ./modules/k8s/newrelic/instrumentation.yaml -n newrelic
    EOF
  }
}