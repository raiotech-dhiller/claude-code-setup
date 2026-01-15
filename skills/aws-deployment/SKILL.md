---
name: aws-deployment
description: |
  AWS deployment workflows including ECS, ECR, Lambda, and CloudFormation.
  Use when deploying to AWS, containerizing applications, or setting up
  infrastructure.
---

# AWS Deployment

## Container Deployment Flow
1. Build: `docker build -t app-name .`
2. Tag: `docker tag app-name:latest <account>.dkr.ecr.<region>.amazonaws.com/app-name:latest`
3. Push: `docker push <account>.dkr.ecr.<region>.amazonaws.com/app-name:latest`
4. Update: `aws ecs update-service --cluster <cluster> --service <service> --force-new-deployment`

## Key Commands
```bash
# ECR login
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account>.dkr.ecr.<region>.amazonaws.com

# Force new deployment
aws ecs update-service --cluster <cluster> --service <service> --force-new-deployment

# Tail logs
aws logs tail /ecs/<service> --follow

# Describe service
aws ecs describe-services --cluster <cluster> --services <service>
```

## CloudFormation Patterns
```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: Service infrastructure

Parameters:
  Environment:
    Type: String
    AllowedValues: [dev, staging, prod]

Resources:
  # Define resources
```

## Best Practices
- Infrastructure as code always
- Blue-green deployments
- Auto-scaling based on metrics
- Comprehensive CloudWatch alarms
- Least-privilege IAM roles
