variable "bucket_name" {
  description = "Bucket Name"
  type        = string
}

variable "tags" {
  description = "Bucket Tags"
  type        = map(string)
  default     = {}
}
