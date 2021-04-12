variable "client_id" {
    default = "xx"
}

variable "client_secret" {
    default = "xx"
}

variable "range" {
   description = "virtual network range"
   default = ["10.0.0.0/16"]
}

variable "agent_count" {
    default = 1
}

variable "ssh_public_key" {
    default = "~/.ssh/id_rsa.pub"
}

variable "dns_prefix" {
    default = "k8stest"
}

variable cluster_name {
    default = "k8stest"
}

variable resource_group_name {
    default = "azure-k8stest"
}

variable location {
    default = "Central US"
}

variable log_analytics_workspace_name {
    default = "testLogAnalyticsWorkspaceName"
}

# refer https://azure.microsoft.com/global-infrastructure/services/?products=monitor for log analytics available regions
variable log_analytics_workspace_location {
    default = "centralus"
}

# refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing
variable log_analytics_workspace_sku {
    default = "PerGB2018"
}

variable public_ip_sku {
    description = "can be Basic or Standard"
    default = "Standard"
}

variable pub_ip_alloc_method {
    description = "can be Static or Dynamic, Stranrd public ip sku requires Static"
    default = "Static"
}

variable aks_cluster_node_resource_group {}
