resource "yandex_storage_bucket" "desema-cloud-bucket" {
  bucket = "desema-cloud-bucket"
}

resource "yandex_storage_bucket" "desema-cloud-public-bucket" {
  bucket = "desema-cloud-public-bucket"
  acl    = "public-read"
}

resource "yandex_storage_object" "cat-picture" {
  bucket = "desema-cloud-public-bucket"
  key    = "cat.jpg"
  source = "./cat.jpg"
}