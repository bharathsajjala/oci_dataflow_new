variable "compartment_id"{default="cid"}
variable "tenancy_ocid" {}
variable "region" {}

variable "compartment_name" {
  type        = string
  description = "The id of the machine image (AMI) to use for the server."
  default = "tf-df-compartment"
}
variable "bucket_name"{default="tf-df-logs"}

variable "bucket_name_warehouse"{default="tf-df-warehouse"}
variable "bucket_namespace"{default="bigdatadatasciencelarge"}
variable "current_user_ocid"{}

