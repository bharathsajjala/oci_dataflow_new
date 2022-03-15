resource "oci_identity_compartment" "tf-compartment" {
    # Required
    compartment_id = var.tenancy_ocid
    description = "Compartment for Terraform resources."
    name = var.compartment_name

}


  resource "oci_objectstorage_bucket" "logbucket" {
      #Required
      compartment_id = oci_identity_compartment.tf-compartment.id
      name = var.bucket_name
      namespace = var.bucket_namespace

    }
  resource "oci_objectstorage_bucket" "warehousebucket" {
      #Required
      compartment_id = oci_identity_compartment.tf-compartment.id
      name = var.bucket_name_warehouse
      namespace = var.bucket_namespace

    }

  resource "oci_identity_group" "tf_df_admingroup" {
      compartment_id = var.tenancy_ocid
      name           = "tf_df_admin_group"
      description    = "dataflow_admin_group description "
    }
  resource "oci_identity_group" "tf_df_usergroup" {
      compartment_id = var.tenancy_ocid
      name           = "tf_df_user_group"
      description    = "dataflow_user_group description"
    }


        resource "oci_identity_user_group_membership" "adduser1_to_group" {

          group_id = oci_identity_group.tf_df_admingroup.id
          user_id = var.current_user_ocid
        }

        resource "oci_identity_user_group_membership" "adduser2_to_group" {

          group_id = oci_identity_group.tf_df_usergroup.id
          user_id = var.current_user_ocid
          #"ocid1.user.oc1..aaaaaaaabkdp6ctxycivjxz7bdwknf36emr6zuqblkudvkaot5hes263gvca"
        }

         resource "oci_identity_policy" "tf_df_adm_policy" {
            #Required
            compartment_id = oci_identity_compartment.tf-compartment.id
            description = "var.policy_description"
            name = "tf_df_admin_policy"
            statements = ["ALLOW GROUP tf_df_admin_group TO READ buckets IN compartment tf-df-compartment",
             "ALLOW GROUP tf_df_admin_group TO MANAGE dataflow-family IN compartment tf-df-compartment",
             "ALLOW GROUP tf_df_admin_group TO MANAGE objects IN compartment tf-df-compartment WHERE ALL{target.bucket.name='tf-df-logs', any {request.permission='OBJECT_CREATE',request.permission='OBJECT_INSPECT'}}"]

        }

           resource "oci_identity_policy" "tf_df_usr_policy" {
            #Required
            compartment_id = oci_identity_compartment.tf-compartment.id
            description = "var.policy_description"
            name = "tf_df_usr_policy"
            statements = ["ALLOW GROUP tf_df_user_group TO READ buckets IN compartment tf-df-compartment",
             "ALLOW GROUP tf_df_user_group TO USE dataflow-family IN compartment tf-df-compartment",
             "ALLOW GROUP tf_df_user_group TO MANAGE dataflow-family IN compartment tf-df-compartment WHERE ANY {request.user.id = target.user.id, request.permission = 'DATAFLOW_APPLICATION_CREATE',request.permission = 'DATAFLOW_RUN_CREATE'}"]

        }
        resource "oci_identity_policy" "tf_df_service_policy" {
            #Required
            compartment_id = oci_identity_compartment.tf-compartment.id
            description = "var.policy_description"
            name = "tf_df_service_policy"
            statements = ["ALLOW SERVICE dataflow TO READ objects IN compartment tf-df-compartment WHERE target.bucket.name='tf-df-logs'"]
        }
