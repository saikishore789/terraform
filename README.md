# terraform
terraform practice

# HashiCorp Vault Dynamic Secrets generation
1. Enable the secret engine path for AWS 

        $ vault secrets enable -path=aws aws

2. View the secret list

        $ vault secrets list

3. Write AWS root config inside your hashicorp vault

        $ vault write aws/config/root \
                access_key=YOUR_ACCESS_KEY \
                secret_key=YOUR_SECRET_KEY \
                region=eu-north-1

4. Setup role 

        $ vault write aws/roles/my-ec2-role \
                credential_type=iam_user \
                policy_document=-EOF
        {
          "Version": "2012-10-17",
          "Statement": [
            {
              "Sid": "Stmt1426528957000",
              "Effect": "Allow",
              "Action": [
                "ec2:*"
              ],
              "Resource": [
                "*"
           ]
            }
          ]
        }
        EOF

6. Generate access key and secret key for that role

        $ vault read aws/creds/my-ec2-role


7.  Revoke the secrets if you do not want it any longer

        $ vault lease revoke aws/creds/my-ec2-role/J8WHZJ5NItdH23KYYHdORv3K
