
local_ec2_data =  <<EOF
#!/bin/bash
apt update -y
apt upgrade -y
apt install nginx -y
apt install mysql-client -y
EOF
