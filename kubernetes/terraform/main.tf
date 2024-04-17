terraform {
  required_version = ">= 0.13.0"
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

resource "yandex_kubernetes_cluster" "k8s_cluster_reddit" {
  name        = "app-reddit"
  description = "Reddit app cluster"
  network_id  = var.network_id

  master {
    version = "1.26"
    zonal {
      zone      = var.zone
      subnet_id = var.subnet_id
    }

    public_ip = true

    maintenance_policy {
      auto_upgrade = true
    }

    master_logging {
      enabled                    = true
      kube_apiserver_enabled     = true
      cluster_autoscaler_enabled = true
      events_enabled             = true
      audit_enabled              = true
    }
  }

  service_account_id      = var.service_account_id
  node_service_account_id = var.service_account_id

  labels = {
    application = "app-reddit"
    environment = "dev"
  }

  release_channel         = "RAPID"
  network_policy_provider = "CALICO"
}

resource "yandex_kubernetes_node_group" "reddit_node_group" {
  cluster_id  = yandex_kubernetes_cluster.k8s_cluster_reddit.id
  name        = "work-node"
  description = "description"
  version     = "1.26"

  labels = {
    application = "reddit"
    environment = "dev"
  }

  instance_template {
    platform_id = "standard-v2"

    network_interface {
      nat        = true
      subnet_ids = [var.subnet_id]
    }

    resources {
      memory = 4
      cores  = 2
    }

    boot_disk {
      type = "network-ssd"
      size = 40
    }

    scheduling_policy {
      preemptible = true
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    fixed_scale {
      size = 1
    }
  }

  allocation_policy {
    location {
      zone = var.zone
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true
  }
}
