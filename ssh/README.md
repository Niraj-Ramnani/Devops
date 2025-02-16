# 🚀 SSH Login on RHEL Instances in AWS  

## 🔹 Overview  
**SSH (Secure Shell)** is a protocol used to securely connect to remote machines over a network. It allows users to execute commands and manage servers remotely. In this guide, we will configure SSH login on RHEL instances in AWS, enabling password authentication and root login.

---

## 🔹 Steps to Enable SSH Login on RHEL Instances in AWS  

```bash
# ✅ 1. Configure Security Group to Allow ICMP and SSH  

# Open AWS Console → Navigate to EC2  
# Go to Security Groups → Select the Security Group associated with your instance  
# Click "Edit inbound rules" and add:  

# ICMP Rule (Ping Enabled):
# Type: All ICMP - IPv4  
# Source: 0.0.0.0/0 (or specific IPs for security)  

# SSH Rule (Allow SSH Access):
# Type: SSH  
# Port: 22  
# Source: Your IP or Anywhere (0.0.0.0/0)  

# ✅ 2. Switch to Root User & Set Password  

# Login to your EC2 instance  
ssh -i your-key.pem ec2-user@<instance-private-ip>  

# Switch to root user  
sudo -i  

# Set a password for root  
passwd  
# Enter and confirm the new root password  

# ✅ 3. Enable Password Authentication & Permit Root Login  

# Open the SSH configuration file  
vim /etc/ssh/sshd_config  

# Update or add the following parameters:  
PasswordAuthentication yes  
PermitRootLogin yes  

# Modify the cloud-init SSH configuration file as well  
vim /etc/ssh/sshd_config.d/50-cloud-init.conf  
# Ensure it does not override PermitRootLogin yes  

# ✅ 4. Restart SSH Service  

# Restart the SSH service to apply changes  
systemctl restart sshd  

# ✅ 5. Configure /etc/hosts on Test1 (Machine 1)  

# Open the hosts file  
vim /etc/hosts  

# Add an entry for Test2 (Machine 2)  
<private-ip-of-test2>  test2  

# ✅ 6. SSH into the Remote Machine (Test2)  

# Now, you can SSH into Test2 using the hostname  
ssh root@test2  

# Or using the private IP  
ssh root@<private-ip-of-test2>  

## 🎯 Conclusion  
By following these steps, you have successfully configured SSH login on your RHEL instance in AWS. This setup allows password-based SSH login for root while ensuring connectivity using private IPs in a multi-instance AWS environment.

