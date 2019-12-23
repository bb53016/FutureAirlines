#! /bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo chkconfig httpd on
sudo service httpd start
hostValue=$(curl http://169.254.169.254/latest/meta-data/local-hostname)
echo "<h1>Deployed via Terraform wih ELB. Response from: $hostValue </h1>" | sudo tee /var/www/html/index.html
