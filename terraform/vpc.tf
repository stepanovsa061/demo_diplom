resource "yandex_vpc_network" "diplom" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "diplom-subnet-a" {
  name           = var.subnet_a
  zone           = var.zone_a
  network_id     = yandex_vpc_network.diplom.id
  v4_cidr_blocks = var.cidr_a
}

resource "yandex_vpc_subnet" "diplom-subnet-b" {
  name           = var.subnet_b
  zone           = var.zone_b
  network_id     = yandex_vpc_network.diplom.id
  v4_cidr_blocks = var.cidr_b
}
