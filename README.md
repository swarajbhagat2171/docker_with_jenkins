
---
# 🚀 Docker CI/CD Adventure – Super Simple Guide for  My Little Brain 😎

# IMP :- jenkins Username:- sai , password:-1

## 👶 Hello, Little Dev!

Imagine you have a **magic toy factory**. Every time you put a new toy in your toy box (GitHub), the **robot chef (Jenkins)** picks it up, builds it into a **special toy car (Docker container)**, and you can play with it in your **magic window (Browser)**.

This guide will show you **step by step** how to do this, even if you’ve never touched a computer lab before!

---

## 1️⃣ Step 1: Make Your Playground (EC2 Instance)

1. Go to AWS → EC2 → Launch Instance
2. Pick **Ubuntu 22.04 LTS** (this is your playground floor)
3. Choose **t2.micro** (small but enough for toys)
4. Open **magic doors** (ports) so the world can see your toys:

| Port | Purpose                 |
| ---- | ----------------------- |
| 8080 | Jenkins playground      |
| 8081 | Extra fun port for toys |

5. Press **Launch** and save your magic key `.pem` (you need it to enter the playground!)

> ⚠️ Keep your key safe, little buddy! 🔑

---

## 2️⃣ Step 2: Enter Your Playground (Connect to EC2)

```bash
ssh -i <your-key.pem> ubuntu@<EC2_PUBLIC_IP>
```

* `<your-key.pem>` → your magic key
* `<EC2_PUBLIC_IP>` → your playground’s address

---

## 3️⃣ Step 3: Bring Your Tools (Install Git & Docker)

```bash
# Update playground
sudo apt update && sudo apt upgrade -y

# Git = Toy box manager
sudo apt install -y git

# Docker = Magical toy builder
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

# Let your user play with Docker without asking permission
sudo usermod -aG docker ubuntu
```

> ⚠️ Log out and log in again so the magic works ✨

---

## 4️⃣ Step 4: Invite the Robot Chef (Install Jenkins & Java)

```bash
# Add Jenkins magic recipe
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update & install Java (chef’s energy) & Jenkins
sudo apt update
sudo apt install -y fontconfig openjdk-17-jre
sudo apt install -y jenkins

# Start the chef
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Let chef play with Docker toys
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

---

## 5️⃣ Step 5: Get Chef’s Secret Key

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

* Use it to **unlock Jenkins playground** at:
  `http://<EC2_PUBLIC_IP>:8080`

---

## 6️⃣ Step 6: Give Chef GitHub Toy Box Access (Create PAT)

1. Go to GitHub → Settings → Developer Settings → Personal Access Tokens → Generate New Token
2. Name it: `jenkins-token`
3. Give it powers:

   * `repo` → access all toys
   * `admin:repo_hook` → listen to toy updates
4. Copy it somewhere safe 📝

---

## 7️⃣ Step 7: Tell Chef About Your Toy Box (Add Credentials in Jenkins)

1. Go to Jenkins Dashboard → Manage Jenkins → Credentials → Add Credentials (Click on Global) eg :- http://43.205.210.4:8080/manage/credentials/store/system/domain/_/
2. Choose **Username + Password**

   * Username → GitHub username
   * Password → GitHub PAT
   * ID → `github-creds`
3. Click **Create**


> ✅ Now chef can fetch new toys automatically!

---

## 8️⃣ Step 8: Teach Chef How to Build Toys (Jenkins Job)

1. Create **New Freestyle Job** in Jenkins
2. **Source Code** → Git:

   * Repository URL: `https://github.com/PhapaleSai/Docker_CICD.git`
   * Credentials → `github-creds`
3. **Build Triggers** → “GitHub hook trigger for GITScm polling”
4. **Build → Execute Shell**, paste:

```bash
#!/bin/bash

# Remove old toy car if exists
docker rm -f container1 2>/dev/null || true

# Build new toy car
docker build --no-cache -t nginx-image1 .

# Find free door (port) for new toy
PORT=8080
while lsof -i:$PORT >/dev/null 2>&1; do
  PORT=$((PORT+1))
done

# Run toy car
docker run -d -p $PORT:80 --name container1 nginx-image1

echo "Your toy is ready at port $PORT!"
```

---

## 9️⃣ Step 9: Make Robot Listen to Toy Box (GitHub Webhook)

1. Go to GitHub → Settings → Webhooks → Add webhook
2. Payload URL: `http://<EC2_PUBLIC_IP>:8080/github-webhook/`
3. Content type: `application/json`
4. Trigger: **Just push events**

> ⚠️ If playground address changes, update this URL!

---

## 🔟 Step 10: Play with Your Toys! 🧸

1. Push a change to GitHub (like updating `index.html`)
2. Jenkins chef will:

   * Fetch code
   * Build Docker toy
   * Run container on a free port
3. Open your browser: `http://<EC2_PUBLIC_IP>:8081` eg http://13.126.224.209:8081/
5. 🎉 See your new toy (website) magically appear!

---

## 📝 Memory of All Commands

```bash
ls
sudo apt update && sudo apt upgrade -y
sudo apt install -y git
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu
exit
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install -y fontconfig openjdk-17-jre
sudo apt install -y jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
sudo su - jenkins
docker ps
tail -f /var/log/jenkins/jenkins.log
sudo journalctl -u jenkins -f
history
```

---

## 🖼 Little Brain Diagram 🧠

```
GitHub (Toy Box)
      │ Push
      ▼
Webhook (Shouts “Hey Chef!”)
      ▼
Jenkins (Chef)
      │ Builds & Runs
      ▼
Docker Container (Toy Car)
      ▼
Browser (Your Eyes)
```

💡 **Explanation:**

* Push code → Chef hears → Chef builds toy → Toy runs → You play!

---

Absolutely! We can add a **super simple 5-year-old style note** about the EC2 restart and updating the GitHub webhook URL. Here’s how it fits into the README:

---

## ⚠️ Important Little Brain Note – Restarting Playground 🛠️

If you **stop and start your EC2 instance**, your playground’s address (public IP) might **change**.

💡 What to do:

1. Go to GitHub → Your repo → Settings → Webhooks
2. Click your webhook → Edit → Update **Payload URL**:

   ```
   http://<NEW_EC2_PUBLIC_IP>:8080/github-webhook/
   ```
3. Save it ✅

---

## 🎉 Congratulations, Little Dev!

* Every time you push to GitHub → Chef Jenkins builds your toy → Docker runs it → you see it in browser
* You are now a **DevOps wizard**! 🧙‍♂️

---






