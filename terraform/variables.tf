###cloud vars


variable "token" {
  type        = string
  default     = "y0_AgAAAABvVAmAAATuwQAAAADsIagyYwP7PEmkR4mLzkLrnsMZmNPULYg"
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  default     = "b1gr9jc87b7932t58r8n"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  default     = "b1gd4iu9i673fhlkf5lf"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "bucket_name" {
  type        = string
  default     = "storage-diplom"
  description = "VPC network&subnet name"
}

variable "exclude_ansible" {
  type        = bool
  default     = false
}


variable "ssh_public_key" {
  description = "SSH public key"
  type        = string
  default     = ""
}

variable "account_name" {
  description = "имя SA для Kubernetes "
  default = "SA-kub"

}
