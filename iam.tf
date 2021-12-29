resource "yandex_iam_service_account" "ig-manager" {
  name        = "ig-manager"
  description = "service account to manage IG"
}

resource "yandex_resourcemanager_folder" "netology" {
  name = "netology"
}

resource "yandex_resourcemanager_folder_iam_member" "admin" {
  folder_id = "${yandex_resourcemanager_folder.netology.id}"
  role = "editor"
  member = "serviceAccount:${yandex_iam_service_account.ig-manager.id}"
  
}
