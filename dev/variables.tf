variable "aws_region" {
  description = "AWS Default Region"
  type        = string
  default     = "eu-west-1"
}

variable "bucket_name" {
  description = "Bucket name for the static website (must be globally unique)"
  type        = string
  default     = "practica-final-toni-keepcoding-2026"
}
