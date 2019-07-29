variable "access_key" {
  default = "AKIA1234567890QWERTY"
}
variable "secret_key" {
  default = "QWERTYUIOPASDFGHJKLZXCVBNMQWERTYUIOPASDF"
}
variable "region" {
  default = "us-east-1"
}
variable "account_id" {
  default = "012345678910"
}
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}
