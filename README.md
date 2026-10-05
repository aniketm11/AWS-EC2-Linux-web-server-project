# AWS Project Assignment – Question 2

## Deploy a Linux Web Server on Amazon EC2 and Secure It Using a Security Group

**Cloud Provider:** Amazon Web Services (AWS)  
**Service:** Amazon EC2  
**Operating System:** Amazon Linux  
**Web Server:** Nginx  
**Region used for this implementation:** US East (N. Virginia) – `us-east-1`

---

## 1. Objective

Deploy a Linux web server on Amazon EC2 and secure it using an appropriate Security Group.

The implementation must:

- Launch a Linux EC2 instance.
- Configure a Security Group.
- Allow only the required HTTP, HTTPS, and SSH inbound traffic.
- Install and run Nginx.
- Verify that the web server is accessible.
- Explain why each allowed port is required.
- Document the configuration and testing results.

---

## 2. Architecture

```text
                         Internet
                            |
                            v
                 +---------------------+
                 |   EC2 Security     |
                 |       Group        |
                 +---------------------+
                   |       |       |
                 :22     :80     :443
                  SSH     HTTP    HTTPS
                   |       |       |
                   +-------+-------+
                           |
                           v
                  +----------------+
                  |   Amazon EC2    |
                  |  Amazon Linux   |
                  |                 |
                  |     Nginx       |
                  +--------+--------+
                           |
                           v
                       Web Page
```

---

## 3. EC2 Configuration

The EC2 instance used for the implementation was:

| Configuration | Value |
|---|---|
| Instance Name | Linux-Web-Server |
| Instance Type | t3.micro |
| Operating System | Amazon Linux |
| Region | us-east-1 |
| Availability Zone | us-east-1c |
| Web Server | Nginx |
| Instance State | Running |

The instance passed its status checks successfully.

---

## 4. Security Group Configuration

The Security Group used by the EC2 instance contains three inbound rules.

| Type | Protocol | Port | Source | Purpose |
|---|---|---:|---|---|
| SSH | TCP | 22 | 0.0.0.0/0* | Remote Linux administration |
| HTTP | TCP | 80 | 0.0.0.0/0 | Public HTTP web access |
| HTTPS | TCP | 443 | 0.0.0.0/0 | Public HTTPS web access |

### Security note

For a production environment, SSH port 22 should be restricted to a trusted administrator IP address or VPN/bastion host rather than exposed to the entire Internet.

In the captured assignment configuration, SSH is currently open to `0.0.0.0/0`. This is acceptable only for temporary lab/testing purposes. After testing, change SSH source to **My IP** or another trusted CIDR.

---

## 5. Why Each Port Is Required

### Port 22 – SSH

**Protocol:** TCP

SSH (Secure Shell) is used to securely connect to and administer the Linux EC2 instance.

Examples:

```bash
ssh -i linux-web-server-key.pem ec2-user@<PUBLIC-IP>
```

For better security, SSH should normally be limited to the administrator's IP address.

---

### Port 80 – HTTP

**Protocol:** TCP

Port 80 is the standard port for HTTP traffic.

It allows users to access the Nginx web server using:

```text
http://<PUBLIC-IP>
```

It is required to demonstrate that the EC2 web server is publicly reachable.

---

### Port 443 – HTTPS

**Protocol:** TCP

Port 443 is the standard port for HTTPS traffic.

It is used for encrypted web communication:

```text
https://<DOMAIN>
```

Opening port 443 in the Security Group permits HTTPS traffic, but HTTPS is not fully operational until an SSL/TLS certificate and Nginx HTTPS configuration are installed.

---

## 6. Connecting to the EC2 Instance

The instance was accessed using EC2 Instance Connect / SSH.

After connecting, the following command was used:

```bash
whoami
```

Expected output:

```text
ec2-user
```

This confirms that the Linux shell session is running as the EC2 default user.

---

## 7. Install Nginx

Update the Amazon Linux packages:

```bash
sudo yum update -y
```

Install Nginx:

```bash
sudo yum install nginx -y
```

Verify the installation:

```bash
nginx -v
```

---

## 8. Start Nginx

Start the service:

```bash
sudo systemctl start nginx
```

Enable Nginx at boot:

```bash
sudo systemctl enable nginx
```

Check its status:

```bash
sudo systemctl status nginx
```

Expected result:

```text
Active: active (running)
```

---

## 9. Nginx Web Root

The default Nginx web root is:

```text
/usr/share/nginx/html/
```

The default web page can be inspected with:

```bash
cd /usr/share/nginx/html
ls
cat index.html
```

For a custom assignment page, `index.html` can be replaced with a custom HTML file.

Example:

```html
<!DOCTYPE html>
<html>
<head>
    <title>AWS EC2 Web Server</title>
</head>
<body>
    <h1>Welcome to My AWS EC2 Web Server</h1>
    <p>Nginx is running successfully on Amazon EC2.</p>
</body>
</html>
```

---

## 10. Testing

### Test Nginx locally

Run:

```bash
curl http://localhost
```

If HTML is returned, Nginx is serving the page locally.

### Test from a browser

Open:

```text
http://<PUBLIC-IP>
```

The Nginx welcome page was successfully displayed in the browser during testing.

### Test service status

```bash
sudo systemctl status nginx
```

### Check listening ports

```bash
sudo ss -tulnp
```

This can be used to verify that Nginx is listening for web traffic.

---

## 11. Evidence / Screenshots

The `screenshots/` directory contains the screenshots supplied during implementation.

### Screenshot 1 – EC2 Instance

Shows:

- `Linux-Web-Server`
- Instance state: Running
- Instance type: `t3.micro`
- Availability Zone: `us-east-1c`
- Public IPv4 address
- Status checks passed

### Screenshot 2 – Security Group

Shows the three inbound rules:

- HTTP – TCP 80
- HTTPS – TCP 443
- SSH – TCP 22

### Screenshot 3 – Linux Terminal

Shows:

```bash
whoami
```

with the result:

```text
ec2-user
```

and the command history containing Nginx installation/start/enable/status commands.

### Screenshot 4 – Nginx Web Page

Shows the Nginx welcome page accessed through the EC2 public IP.

### Screenshot 5 – Command History

Shows the commands used during the Nginx setup.

---

## 12. Security Considerations

The Security Group follows the principle of allowing only the ports required for this assignment.

### Recommended production configuration

| Port | Recommended Source |
|---:|---|
| 22 | Administrator's public IP / VPN / bastion host |
| 80 | `0.0.0.0/0` if HTTP is required |
| 443 | `0.0.0.0/0` |

Additional security recommendations:

1. Do not expose SSH to the entire Internet in production.
2. Use key-based authentication.
3. Keep Amazon Linux and Nginx updated.
4. Use HTTPS with a valid TLS certificate.
5. Remove unnecessary inbound rules.
6. Never expose database ports such as 3306 publicly unless there is a specific, controlled requirement.
7. Do not commit private SSH keys to GitHub.

---

## 13. Final Result

The Linux web server was successfully deployed on Amazon EC2 using Amazon Linux and Nginx.

The EC2 instance was running and passed its status checks. The Security Group contained rules for SSH, HTTP, and HTTPS. Nginx was installed, started, and enabled. The Nginx web page was successfully accessed through the EC2 public IPv4 address.

**Result: PASS – Question 2 implementation completed.**

---

## 14. Quick Command Reference

```bash
# Update packages
sudo yum update -y

# Install Nginx
sudo yum install nginx -y

# Start Nginx
sudo systemctl start nginx

# Enable Nginx at boot
sudo systemctl enable nginx

# Check Nginx
sudo systemctl status nginx

# Check Nginx version
nginx -v

# Go to web root
cd /usr/share/nginx/html

# List web files
ls

# Test locally
curl http://localhost

# Check listening ports
sudo ss -tulnp

# Check current user
whoami
```

---

## 15. Submission Checklist

- [x] EC2 Linux instance launched
- [x] Security Group configured
- [x] SSH port 22 configured
- [x] HTTP port 80 configured
- [x] HTTPS port 443 configured
- [x] Nginx installed
- [x] Nginx started
- [x] Nginx enabled at boot
- [x] Web page tested from browser
- [x] Screenshots included
- [x] Port explanations documented
- [x] Security recommendations documented

