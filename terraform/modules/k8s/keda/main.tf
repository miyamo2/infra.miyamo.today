resource "helm_release" "this" {
  name             = "keda"
  chart            = "keda"
  namespace        = "keda"
  create_namespace = true
  repository       = "https://kedacore.github.io/charts"
}