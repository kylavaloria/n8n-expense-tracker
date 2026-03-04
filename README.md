## Architecture
Telegram -> n8n -> LLM parsing -> Google Sheets -> scheduled summaries

## Deployment Flow
Terraform provisions Azure infrastructure and deploys Azure Container Apps running `n8nio/n8n:latest` with persistent Azure File Share storage mounted at `/home/node/.n8n`.

## Local Development
```bash
docker compose up
```

## Cloud Deployment
```bash
cd infra/terraform
terraform init
terraform plan
terraform apply
```

