
---

## **Step 1: Launch an Ubuntu Instance in AWS**  
1. **Log in to AWS Console**  
2. Go to **EC2** → Click **Launch Instance**  
3. **Choose Ubuntu** (latest LTS version recommended)  
4. **Instance Type** → Choose `t2.micro` (free tier) or higher  
5. **Key Pair** → Create or select an existing key pair (you’ll need this to SSH)  
6. **Security Group** → Allow:  
   - **SSH (22)** → Your IP  
   - **Prometheus (9090)** → Anywhere or a specific IP  
7. Click **Launch**  

---

## **Step 2: Connect to Your Ubuntu Instance**  
Once the instance is running, connect using SSH:  
```sh
ssh -i your-key.pem ubuntu@your-ec2-public-ip
```

---

## **Step 3: Install Prometheus on Ubuntu**  
###1️⃣ Update & Install Dependencies  
```sh
sudo apt update && sudo apt install -y wget curl tar
```

### 2️⃣ Create Prometheus User  
```sh
sudo useradd --no-create-home --shell /bin/false prometheus
```

### 3️⃣ Download Prometheus  
```sh
wget https://github.com/prometheus/prometheus/releases/latest/download/prometheus-linux-amd64.tar.gz
```

### 4️⃣ Extract & Move Files  
```sh
tar xvf prometheus-linux-amd64.tar.gz
cd prometheus-*
sudo mv prometheus /usr/local/bin/
sudo mv promtool /usr/local/bin/
```

### 5️⃣ Verify Installation  
```sh
prometheus --version
```

---

## **Step 4: Configure Prometheus**  
### 1️⃣ Create Config Directory  
```sh
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus
```

### 2️⃣ Move Config Files  
```sh
sudo mv consoles /etc/prometheus
sudo mv console_libraries /etc/prometheus
sudo mv prometheus.yml /etc/prometheus
sudo chown -R prometheus:prometheus /etc/prometheus
```

### 3️⃣ Edit Prometheus Config  
```sh
sudo nano /etc/prometheus/prometheus.yml
```
**Basic Config (Modify as needed):**  
```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
```
Save & exit (`CTRL + X`, then `Y`, then `ENTER`).

---

## **Step 5: Create a Prometheus Service**  
```sh
sudo nano /etc/systemd/system/prometheus.service
```
**Add the following:**  
```ini
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
```
Save & exit (`CTRL + X`, `Y`, `ENTER`).

---

## **Step 6: Start & Enable Prometheus**  
```sh
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus
sudo systemctl status prometheus
```

---

## **Step 7: Open Firewall & Access Prometheus UI**  
### 1️⃣ Allow Port 9090  
```sh
sudo ufw allow 9090/tcp
sudo ufw enable
```
If using AWS **Security Groups**, ensure **port 9090** is open.

### 2️⃣ Access Prometheus  
Open your browser and go to:  
```
http://<your-ec2-public-ip>:9090
```

---

## **Next Steps**  
✅ Prometheus is up! Now, you can:  
- Add **Node Exporter** to monitor EC2 instance metrics  
- Integrate **Grafana** for visualization  
- Add more targets like Docker containers, applications, etc.

