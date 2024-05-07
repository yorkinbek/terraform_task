Backend is configured default for QA environment. To configure for prod environment use the following command.


$ terraform init -backend-config=prodbackend.tfvars
$ terraform apply -var="env=prod"    