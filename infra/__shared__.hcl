remote_state {
    backend = "s3"

    generate = {
        path = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }

    config = {
        bucket = "donggyu-gitops-state"
        key = "${path_relative_to_include()}/terraform.tfstate"
        region = "ap-northeast-2"
        encrypt = true
        assume_role = {
            role_arn = "arn:aws:iam::${get_aws_account_id()}:role/TerraformAssumedRole"
        }
    }
}

generate "provider" {
    path = "provider.tf"
    if_exists = "skip"
    contents = <<EOF
    provider "aws" {
        region = "ap-northeast-2"
        assume_role {
            role_arn = "arn:aws:iam::${get_aws_account_id()}:role/TerraformAssumedRole"
        }
    }
EOF
}

generate "locals" {
    path = "locals.tf"
    if_exists = "overwrite_terragrunt"

    contents = <<EOF
    locals {
        network = jsondecode(var.network)
        sg = jsondecode(var.sg)
        alb = jsondecode(var.alb)
    }
    EOF
}

generate "terraform" {
    path = "vars.tf"
    if_exists = "overwrite_terragrunt"

    contents = <<EOF

    data "aws_caller_identity" "current" {}
    variable "network" {}
    variable "sg" {}
    variable "alb" {}

    EOF
}

dependency "network" {
    config_path = find_in_parent_folders("vpc")

    mock_outputs = {
        out = {}
    }
}

dependency "sg" {
    config_path = find_in_parent_folders("sg")

    mock_outputs = {
        out = {}
    }
        
}

dependency "alb" {
    config_path = find_in_parent_folders("alb")

    mock_outputs = {
        out = {}
    }
}

inputs = {
    network = dependency.network.outputs.out
    sg = dependency.sg.outputs.out
    alb = dependency.alb.outputs.out
}