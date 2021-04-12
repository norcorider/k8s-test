variable "client_id" {
  description = "Azure Kubernetes Service Cluster service principal"
}
variable "client_secret" {
  description = "Azure Kubernetes Service Cluster password"
}
variable "location" {
  description = "Azure resources location"
  default = "Central US"
}
variable "resource_group_name" {
  description = "Azure resources group"
  default = "aks-resource-group-demo"
}
variable "cluster_name" {
  description = "Azure AKS cluster name"
  default = "aks-cluster-test"
}
variable "agent_count" {
    default = 1
}
variable "admin_username" {
  description = "Azure AKS nodes admin account username"
  default = "demo"
}
variable "default_namespace" {
  description = "Namespace where to deploy things on K8s"
  default     = "default"
}

variable "ingress_name" {
  default = "helm-ingress-nginx"
}
variable "ingress_namespace" {
  default   = "ingress-nginx-ns"
}
variable "ingress_controller_class" {
  default = "ingress-nginx-class"
}
variable "ingress_azurerm_dns_zone" {
  default = "example.com"
}
