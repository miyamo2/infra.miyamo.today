data "google_client_openid_userinfo" "terraform_user" {}

resource "terraform_data" "namespace" {
  triggers_replace = {
    "config_context" = var.config_context
  }
  provisioner "local-exec" {
    command = <<EOF
      kubectl create namespace argocd
    EOF
  }
}

resource "terraform_data" "clusterrolebinding" {
  triggers_replace = {
    "config_context" = var.config_context
  }
  provisioner "local-exec" {
    command = <<EOF
      kubectl create clusterrolebinding argocd-cluster-role-binding --clusterrole=cluster-admin --user=${data.google_client_openid_userinfo.terraform_user.email}
    EOF
  }
}

locals {
  argocd_manifest = "https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
}

resource "terraform_data" "this" {
  triggers_replace = {
    "config_context"  = var.config_context
    "argocd_manifest" = local.argocd_manifest
  }
  provisioner "local-exec" {
    command = <<EOF
      kubectl apply -n argocd -f ${local.argocd_manifest}
    EOF
  }
  depends_on = [terraform_data.clusterrolebinding, terraform_data.namespace]
}