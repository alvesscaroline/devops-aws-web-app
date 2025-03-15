# **CI/CD AWS Deployment – Nginx Static Website**

## **Overview**
This project demonstrates a fully automated **CI/CD pipeline** to deploy a static website using **AWS services, Terraform, Docker, and GitHub Actions**. The pipeline includes **automated testing, containerization, and deployment to an EC2 instance**, ensuring a streamlined and efficient DevOps workflow.

The primary objectives of this project are:
- Automate the deployment process using **GitHub Actions**.
- Containerize the application with **Docker** and push images to **AWS ECR**.
- Deploy the application to an **AWS EC2 instance** using **Terraform** for infrastructure as code.
- Run **automated tests** before deployment.
- Implement a **rollback mechanism** in case of a failed deployment.

## **Technologies Used**
- **Infrastructure as Code:** Terraform
- **Containerization & Orchestration:** Docker, Docker Compose
- **Cloud Provider:** AWS (EC2, ECR, IAM)
- **CI/CD Automation:** GitHub Actions
- **Configuration Management:** SSH, AWS CLI
- **Testing Framework:** Pytest
- **Web Server:** Nginx
- **Version Control:** Git & GitHub

## **Project Structure**
```
.
├── .github/workflows/deploy.yml   # GitHub Actions workflow for CI/CD
├── terraform/                     # Terraform configurations
│   ├── main.tf                     # Infrastructure as code definition
│   ├── variables.tf                 # Terraform variables
│   ├── outputs.tf                   # Terraform outputs
├── docker/                          # Docker configurations
│   ├── Dockerfile                    # Production Dockerfile
│   ├── docker-compose.test.yml       # Docker Compose file for testing
│   ├── index.html                    # Static HTML file served by Nginx
├── tests/                            # Automated tests
│   ├── test_app.py                   # Test script to verify Nginx is running
├── requirements.txt                  # Dependencies for testing
├── README.md                         # Project documentation
```


## **Infrastructure Setup (AWS)**
This project uses **Terraform** to provision AWS infrastructure, including:
- **EC2 Instance** (t2.micro) for hosting the application.
- **Security Groups** to allow HTTP (80) and SSH (22) traffic.
- **IAM Role & Policies** to grant permissions for ECR.
- **Key Pair** for secure SSH authentication.

### **Deploying Infrastructure with Terraform**
1. **Initialize Terraform:**
   ```bash
   terraform init
   ```
2. **Plan deployment:**
   ```bash
   terraform plan
   ```
3. **Apply changes:**
   ```bash
   terraform apply -auto-approve
   ```
4. **Retrieve the public IP of EC2:**
   ```bash
   terraform output public_ip
   ```

---

## **Containerization & Testing**
This project containerizes the static website using **Docker** and ensures it is functional with automated tests before deployment.

### **Docker**
- The production **Dockerfile** builds an Nginx-based container serving `index.html`.
- The **Docker Compose** file (`docker-compose.test.yml`) is used for running integration tests.

### **Running Tests Locally**
1. Ensure **Docker and Docker Compose** are installed.
2. Run tests:
   ```bash
   docker compose -f docker/docker-compose.test.yml up --build
   ```


## **CI/CD Pipeline – GitHub Actions**
The deployment process is fully automated using **GitHub Actions**, ensuring each commit triggers a sequence of steps:

### **Pipeline Stages**
1. **Run Automated Tests**
   - Builds a test container.
   - Executes `pytest` to verify Nginx is running.
   - If tests fail, the pipeline stops.

2. **Build & Push Docker Image**
   - Builds the Docker image from `docker/Dockerfile`.
   - Tags and pushes the image to **AWS ECR**.

3. **Deploy to AWS EC2**
   - SSHs into the EC2 instance.
   - Pulls the latest Docker image.
   - Stops and removes the previous container.
   - Runs the new container.

4. **Rollback on Failure**
   - If the deployment fails, the workflow rolls back to the previous working image.

### **Workflow Configuration (deploy.yml)**
The pipeline is defined in `.github/workflows/deploy.yml` and runs on every push to `main`.


## **Deploying Manually**
If needed, the deployment can be done manually:

### **1. Authenticate AWS ECR**
```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <AWS_ECR_URL>
```

### **2. Build & Push Docker Image**
```bash
docker build -t my-web-app -f docker/Dockerfile ./docker
docker tag my-web-app:latest <AWS_ECR_URL>/my-web-app:latest
docker push <AWS_ECR_URL>/my-web-app:latest
```

### **3. Deploy to EC2**
```bash
ssh -i key-ec2.pem ubuntu@<EC2_PUBLIC_IP> << EOF
    sudo docker pull <AWS_ECR_URL>/my-web-app:latest
    sudo docker stop my-web-app || true
    sudo docker rm my-web-app || true
    sudo docker run -d -p 80:80 --name my-web-app <AWS_ECR_URL>/my-web-app:latest
EOF
```


## **Handling Rollback**
If the new deployment fails, a **rollback** is triggered automatically. However, it can also be done manually:

### **1. SSH into the EC2 Instance**
```bash
ssh -i key-ec2.pem ubuntu@<EC2_PUBLIC_IP>
```

### **2. Rollback to Previous Version**
```bash
sudo docker stop my-web-app
sudo docker rm my-web-app
sudo docker run -d -p 80:80 --name my-web-app <AWS_ECR_URL>/my-web-app:previous
```

## **Contributors**
- **Caroline Alves** – DevOps Engineer