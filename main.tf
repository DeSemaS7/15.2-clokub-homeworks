terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "desema-cloud-bucket"
    region     = "us-east-1"
    key        = "tfstates/terraform.tfstate"
    access_key = var.YC_STORAGE_ACCESS_KEY
    secret_key = var.YC_STORAGE_SECRET_KEY

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

provider "yandex" {
  token              = var.YC_TOKEN
  cloud_id           = "b1ge9kc6o4mjqkq8g442"
  folder_id          = "b1g4b2ub71c1gaf00cp8"
  zone               = "ru-central1-a"
  storage_access_key = var.YC_STORAGE_ACCESS_KEY
  storage_secret_key = var.YC_STORAGE_SECRET_KEY
}



