variable "env" {
    type = string
}

variable "rg_name" {
  type = map(string)
  default = {
    qa = "Resources-QA"
    prod = "Resources-Prod"
  }
}

variable "rg_location" {
    type = string
    default = "eastus"

}