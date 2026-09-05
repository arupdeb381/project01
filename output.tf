output "web_alb_url" {
  description = "Web application URL"
  value       = "http://${module.infra-app.web_alb_dns}"
}

output "bastion_ssh_command" {
  description = "SSH command for bastion host"
  value       = "ssh -i modules/infra-app/terra-key-ec2 ec2-user@${module.infra-app.bastion_public_ip}"
}

output "app_alb_dns" {
  description = "Internal app ALB DNS"
  value       = module.infra-app.app_alb_dns
}

output "db_endpoint" {
  description = "Database endpoint"
  value       = module.infra-app.db_endpoint
  sensitive   = true
}
