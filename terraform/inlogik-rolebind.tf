# define kubernetes cluster role and rolebinding resource
resource "kubernetes_cluster_role" "full_access" {
  metadata {
    name = "full-access"
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

resource "kubernetes_cluster_role_binding" "full_access_binding" {
  metadata {
    name = "full-access-binding"
  }

  subject {
    kind      = "User"
    name      = "pengxiang.chen@nexushub.onmicrosoft.com"
    api_group = "rbac.authorization.k8s.io"
  }

  role_ref {
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.full_access.metadata[0].name
    api_group = "rbac.authorization.k8s.io"
  }
}