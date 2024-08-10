variable "stack_name" {
  description = "The name for stack"
  type        = string
  default     = "recipe-mgt"
}

variable "frontend_image_version" {
  description = "Image version of the frontend"
  type = string
  default = "1.0.7"
}

variable "backend_image_version" {
  description = "Image version of the backend"
  type = string
  default = "1.0.7"
}