variable "aws_common_tag" {
  description = "Specifies object tags key and value."
  type        = map(string)
  default     = {}
}

variable "size" {
  type    = number
  default = 2
}

variable "AZ" {
  type    = string
  default = "eu-west-2b"
}

variable "ec2_instance_type" {
  description = "The type of instance to start. Updates to this field will trigger a stop/start of the EC2 instance."
  type        = string
  default     = "t2.micro"
}

variable "maintainer" {
  description = "Specifies object tags key and value."
  type        = string
  default     = "eazytraining"
}

variable "ssh_key" {
  type    = string
  default = "devops-key"
}


variable "user" {
  type    = string
  default = "ubuntu"
}

variable "elb_ssl_cert" {
  type    = string
  default = ""
}

#--------------------------------------------------------
### Database
variable "rds_instance_type" {
  description = "(Required) The instance type of the RDS instance."
  type        = string
  default     = "db.t2.micro"
}


variable "db_password" {
  description = "DO NOT CHANGE - Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file."
  default     = "dbpass1234567"
  type        = string
}

variable "tags" {
  description = "Specifies object tags key and value."
  type        = map(string)
  default     = {}
}

variable "db_name" {
  description = "DO NOT CHANGE - Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file."
  default     = "dbw"
  type        = string
}

variable "db_username" {
  description = "DO NOT CHANGE - Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file."
  default     = "dbwuser"
  type        = string
}

variable "min_size" {
  type        = number
  default     = 0
}

variable "max_size" {
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "Specifies object tags key and value."
  type        = string
  default     = "t2.micro"
}







