output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "private_subnets_cidr_blocks" {
  description = "CIDR IP ranges for private subnets"
  value       = module.vpc.private_subnets_cidr_blocks
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "public_subnets_cidr_blocks" {
  description = "CIDR IP ranges for public subnets"
  value       = module.vpc.public_subnets_cidr_blocks
}

output "image_repository_url" {
  value = aws_ecr_repository.image_registry.repository_url
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.cluster.arn
}

output "vpc_endpoints_sg_id" {
  value = aws_security_group.vpc_endpoint_sg.id
}

output "s3_vpce_prefix_list_id" {
  value = module.vpc_endpoints.endpoints.s3.prefix_list_id
}