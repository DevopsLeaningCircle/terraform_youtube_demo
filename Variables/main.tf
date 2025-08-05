output "instance_type" {
  value = var.string_type
}

output "number_type" {
  value = var.number_type
}

output "boolean_type" {
  value = var.boolean_type
}

output "list_type" {
  value = var.list_type[0]
}

output "map_type" {
  value = var.map_type["ENV"]
}

output "object_type" {
  value = var.object_type.engine
}