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
    name      = "02fc7d78-a18e-437b-b68c-af14119b8eeb" # Object ID
    api_group = "rbac.authorization.k8s.io"
  }

  role_ref {
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.full_access.metadata[0].name
    api_group = "rbac.authorization.k8s.io"
  }
}

# uat env.
resource "kubernetes_role_binding" "uat_full_access" {
  metadata {
    name      = "namespace-full-access-binding"
    namespace = "uat" 
  }
  subject {
    kind      = "User"
    name      = "190f2af4-5cf0-4b15-802e-d9594c4554f6"
    api_group = "rbac.authorization.k8s.io"
  }
  role_ref {
    kind      = "ClusterRole"
    name      = "full-access"  
    api_group = "rbac.authorization.k8s.io"
  }
}

# prod env.
resource "kubernetes_role_binding" "prod_full_access" {
  metadata {
    name      = "namespace-full-access-binding"
    namespace = "prod" 
  }
  subject {
    kind      = "User"
    name      = "190f2af4-5cf0-4b15-802e-d9594c4554f6"
    api_group = "rbac.authorization.k8s.io"
  }
  role_ref {
    kind      = "ClusterRole"
    name      = "full-access"  
    api_group = "rbac.authorization.k8s.io"
  }
}