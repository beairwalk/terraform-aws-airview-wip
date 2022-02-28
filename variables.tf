variable "tags" {
  description = "Tags to assign to resources"
  type        = map(string)
  default = {
    "CostReference" = "airview-aws-project"
    "Environment"   = "dev"
  }
}
