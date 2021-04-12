resource "azurerm_resource_group" "k8s" {
  name     = var.resource_group_name
  location = var.location
}


resource "azurerm_network_ddos_protection_plan" "example" {
  name                = "ddospplan1"
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name
  address_space       = var.range
  ddos_protection_plan {
    id     = azurerm_network_ddos_protection_plan.example.id
    enable = true
  }
}

resource "azurerm_public_ip" "ip" {
  name                = "ip"
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name
  allocation_method   = var.pub_ip_alloc_method
  sku                 = var.public_ip_sku
}


resource "azurerm_dns_zone" "ingress" {
  name                = var.ingress_azurerm_dns_zone
  resource_group_name = azurerm_resource_group.k8s.name
  depends_on = [
      azurerm_public_ip.ip,
  ]
}

resource "azurerm_dns_a_record" "ingress" {
  name                = "*"
  zone_name           = azurerm_dns_zone.ingress.name
  resource_group_name = azurerm_resource_group.k8s.name
  ttl = 300
  records = [azurerm_public_ip.ip.ip_address]
  depends_on = [
      azurerm_dns_zone.ingress,
  ]

}

resource "random_id" "log_analytics_workspace_name_suffix" {
  byte_length = 8
}

resource "azurerm_log_analytics_workspace" "test" {
  # The WorkSpace name has to be unique across the whole of azure, not just the current subscription/tenant.
  name                = "${var.log_analytics_workspace_name}-${random_id.log_analytics_workspace_name_suffix.dec}"
  location            = var.log_analytics_workspace_location
  resource_group_name = azurerm_resource_group.k8s.name
  sku                 = var.log_analytics_workspace_sku
}

resource "azurerm_log_analytics_solution" "test" {
  solution_name         = "ContainerInsights"
  location              = azurerm_log_analytics_workspace.test.location
  resource_group_name   = azurerm_resource_group.k8s.name
  workspace_resource_id = azurerm_log_analytics_workspace.test.id
  workspace_name        = azurerm_log_analytics_workspace.test.name

  plan {
      publisher = "Microsoft"
      product   = "OMSGallery/ContainerInsights"
  }
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = var.cluster_name
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name
  dns_prefix          = var.dns_prefix

  linux_profile {
      admin_username = "ubuntu"
      ssh_key {
          key_data = file(var.ssh_public_key)
      } 
  }

  default_node_pool {
      name            = "agentpool"
      node_count      = var.agent_count
      vm_size         = "Standard_D2_v2"
  }

  service_principal {
      client_id     = var.client_id
      client_secret = var.client_secret
  }

  addon_profile {
      kube_dashboard {
        enabled = true
      }
      oms_agent {
      enabled                    = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.test.id
      }
  }

  network_profile {
      load_balancer_profile {
          outbound_ip_address_ids = [azurerm_public_ip.ip.id]
      }
      network_plugin = "kubenet"
  }

  tags = {
      Environment = "Development"
  }
}
