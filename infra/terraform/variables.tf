# client id
variable "appId" {
  description = "Azure Kubernetes Service Cluster service principal"
}
# client secrent
variable "password" {
  description = "Azure Kubernetes Service Cluster password"
}

# tenant id
variable "tenantId" {
  description = "Azure tenant id"
}

# subsription id
variable "subscriptionId" {
  description = "Azure subscription id"
}

variable "project_name" {
  description = "Project name"
}