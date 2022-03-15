variable "compartment_id"{}
variable "tenancy_ocid" {}
variable "region" {}

variable "compartment_name" {
  type        = string
  description = "The id of the machine image (AMI) to use for the server."
  default = "terraform_compartment"
}
variable "bucket_name"{default="tf-df-logs"}

variable "bucket_name_warehouse"{}
variable "bucket_namespace"{}
variable "current_user_ocid"{}

