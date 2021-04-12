module "m_test_app" {
  source = "../test-app"
}

module "c_customer_ingress_rules_master" {
  source = "../ingress"
  ingress_namespace = var.ingress_namespace
  ingress_controller_class = var.ingress_controller_class
  ingress_ip_address = var.ingress_ip_address
}
