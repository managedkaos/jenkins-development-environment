variable "name" {
  type        = string
  description = "The name to assign to resources in this module"
}

variable "environment" {
  type        = string
  description = "The environment to assign to resource in this module"
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "Tags to asscociate to taggable resources in this module"
}
