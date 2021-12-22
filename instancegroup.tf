resource "yandex_compute_instance_group" "ig-1" {
  name               = "fixed-ig"
  service_account_id = "aje4audtbr11ce49mleb"
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
    max_unavailable = 3
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
