provider "aws" {
  region = var.region
  ignore_tags {
    keys = ["creator", "eco-creator", "eco-email"]
  }
}
