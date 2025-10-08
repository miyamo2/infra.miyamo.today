resource "helm_release" "this" {
  name             = "keda"
  chart            = "keda"
  repository       = "https://kedacore.github.io/charts"
}