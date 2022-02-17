# Variables for AWS infrastructure module
# Required
variable "aws_access_key" {
  type        = string
  description = "AWS access key used to create infrastructure"
}

# Required
variable "aws_secret_key" {
  type        = string
  description = "AWS secret key used to create AWS infrastructure"
}

variable "aws_region" {
  type        = string
  description = "AWS region used for all resources"
  default     = "us-east-1"
}

variable "route53_zone" {
  type        = string
  description = "AWS route53 zone"
  default     = ""
}

variable "route53_name" {
  type        = string
  description = "AWS route53 domain name"
  default     = "rancher"
}

variable "deploy_lb" {
  type        = bool
  description = "Deploy AWS nlb in front of worker nodes"
  default     = false
}

variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
  default     = "rancher-infra-aws"
}

variable "node_master_count" {
  type        = number
  description = "Master nodes count"
  default     = 0
}

variable "node_worker_count" {
  type        = number
  description = "Worker nodes count"
  default     = 0
}

variable "node_all_count" {
  type        = number
  description = "All roles nodes count"
  default     = 1
}

variable "node_username" {
  type        = string
  description = "Instance type used for all EC2 instances"
  default     = "ubuntu"
}

variable "instance_type" {
  type        = string
  description = "Instance type used for all EC2 instances"
  default     = "t3a.medium"
}

variable "docker_version" {
  type        = string
  description = "Docker version to install on nodes"
  default     = "19.03"
}

variable "ssh_key_file" {
  type        = string
  description = "File path and name of SSH private key used for infrastructure"
  default     = "~/.ssh/id_rsa"
}

variable "ssh_pub_file" {
  type        = string
  description = "File path and name of SSH public key used for infrastructure"
  default     = ""
}

variable "register_command" {
  type        = string
  description = "Register command for nodes"
  default     = ""
}

variable "user_data" {
  type = string
  description = "AWS vm's userdata to cloud-init"
  default = ""
}
variable "clusterid" {
  type        = string
  description = "Unique ID for this cluster"
  default     = "1d776bf9-8283-4ea8-af3a-f8d30646695e"
}
variable "iam_instance_profile" {
  type        = string
  description = "IAM instance profile name to associate with instance"
  default     = ""
}