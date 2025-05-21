# Pass the database credentials as environmental variables
export TF_VAR_db_username="admin"
export TF_VAR_db_password="myadminpass"

- If you do not set this environmental variable on the bash terminal, you will be prompted interactively for the db_username and db_password when you run terraform apply or terraform plan.