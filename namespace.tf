# Create a namespace
resource "kubernetes_namespace" "ns" {
  metadata {
    name = "my-aks-namespace"
  }
  depends_on = [
    azurerm_kubernetes_cluster.firstaks
  ] 
}