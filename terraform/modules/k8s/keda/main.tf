resource "helm_release" "this" {
  name       = "keda"
  chart      = "kedacore/keda"
  repository = "https://kedacore.github.io/charts"
}