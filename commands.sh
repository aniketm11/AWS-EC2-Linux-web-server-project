# AWS Project Assignment – s
# Commands used for Linux + Nginx EC2 deployment

sudo yum update -y
sudo yum install nginx -y
nginx -v
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl status nginx
cd /usr/share/nginx/html
ls
cat index.html
curl http://localhost
sudo ss -tulnp
whoami
history
