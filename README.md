# Домашнее задание к занятию 15.2 "Вычислительные мощности. Балансировщики нагрузки".

1. Создадал [конфиг паблик бакета](storage.tf) и загрузил в него картинку, предварительно сгенерив и прописав ключи доступа в [main.tf](main.tf)
```terraform
resource "yandex_storage_bucket" "desema-cloud-public-bucket" {
  bucket = "desema-cloud-public-bucket"
  acl    = "public-read"
}
resource "yandex_storage_object" "cat-picture" {
  bucket = "desema-cloud-public-bucket"
  key    = "cat.jpg"
  source = "./cat.jpg"
}
```

2. Создал конфиг [инстанс-группы](instancegroup.tf) с проверкой состояний. 
```terraform
resource "yandex_compute_instance_group" "ig-1" {
  name               = "fixed-ig"
  service_account_id = yandex_iam_service_account.ig-manager.id
  instance_template {
    platform_id = "standard-v1"
    resources {
      memory = 2
      cores  = 2
    }
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
      }
    }
    scheduling_policy {
      preemptible = true
    }
    network_interface {
      network_id = yandex_vpc_network.terra_network.id
      subnet_ids = ["${yandex_vpc_subnet.public.id}"]
    }
    metadata = {
      user-data          = "${file("meta.txt")}"
      serial-port-enable = 1
    }
  }
  scale_policy {
    fixed_scale {
      size = 3
    }
  }
  allocation_policy {
    zones = ["ru-central1-a"]
  }
  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }
  load_balancer {
    target_group_name = "balancer-target"
  }
  health_check {
    interval            = 5
    timeout             = 1
    healthy_threshold   = 2
    unhealthy_threshold = 2
    http_options {
      port = 80
      path = "/"
    }
  }
}
```
Убедился в работоспособности хелсчеков остановив апач на одной из вм. после этого она автоматически была пересоздана.

3. После добавил в [настройки сети](networks.tf) секцию с балансиром:

```terraform
resource "yandex_lb_network_load_balancer" "balancer" {
  name = "balancer"

  listener {
    name = "listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  attached_target_group {
    target_group_id = yandex_compute_instance_group.ig-1.load_balancer[0].target_group_id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}
```
Проверил работоспособность и удалением вм и заменой index.html