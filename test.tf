module "k8s" {
  source = "./modules/k8s-cluster"
  cluster_name = "k8stest"
  resource_group_name = "azure-k8stest"
  ingress_azurerm_dns_zone = var.ingress_azurerm_dns_zone
  
}

module "b_ingress_nginx_controller" {
  source = "./modules/ingress-controller"
  ingress_controller_class = var.ingress_controller_class
  ingress_namespace = var.ingress_namespace
  ingress_name = var.ingress_name
  ingress_ip_address = module.k8s.ip_address
  depends_on = [
      module.k8s,
  ]
}

module "c_customers" {
  source = "./modules/test"

  ingress_namespace = var.ingress_namespace
  ingress_controller_class = var.ingress_controller_class
  ingress_azurerm_dns_zone = var.ingress_azurerm_dns_zone

  ingress_ip_address = module.k8s.ip_address

  depends_on = [
      module.k8s,
  ]
}
