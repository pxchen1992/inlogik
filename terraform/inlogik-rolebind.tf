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
    name      = "fb510d71-0114-47a9-a9e4-f48a44ee0348" # User Object ID
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
    name      = "a6bc74d0-171d-44f1-8383-1054873d0b28" # service_principal_object_id
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
    name      = "a6bc74d0-171d-44f1-8383-1054873d0b28" # service_princal
    api_group = "rbac.authorization.k8s.io"
  }
  role_ref {
    kind      = "ClusterRole"
    name      = "full-access"  
    api_group = "rbac.authorization.k8s.io"
  }
}