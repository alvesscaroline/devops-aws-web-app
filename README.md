# **CI/CD AWS Deployment – Nginx Static Website**

## **Overview**
This project demonstrates a fully automated **CI/CD pipeline** to deploy a static website using **AWS services, Terraform, Docker, and GitHub Actions**. The pipeline includes **automated testing, containerization, and deployment to an EC2 instance**, ensuring a streamlined and efficient DevOps workflow.

### **Project Goals**
- Automate deployment using **GitHub Actions**.
- Containerize the application with **Docker** and push images to **AWS ECR**.
- Deploy the application to **AWS EC2** using **Terraform**.
- Run **automated tests** before deployment.
- Implement **monitoring and observability** with **AWS CloudWatch**.
- Enable **automatic rollback** in case of a failed deployment.

## **Technologies Used**
- **Infrastructure as Code:** Terraform
- **Containerization & Orchestration:** Docker, Docker Compose
- **Cloud Provider:** AWS (EC2, ECR, IAM, CloudWatch, SSM)
- **CI/CD Automation:** GitHub Actions
- **Configuration Management:** SSH, AWS CLI
- **Monitoring & Observability:** CloudWatch Logs, CloudWatch Metrics, CloudWatch Agent
- **Testing Framework:** Pytest
- **Web Server:** Nginx
- **Version Control:** Git & GitHub

## **Project Structure**
```
.
├── .github/workflows/deploy.yml   # GitHub Actions workflow for CI/CD
├── terraform/                     # Terraform configurations
│   ├── provider.tf                 # AWS provider configuration
│   ├── variables.tf                 # Terraform variables
│   ├── outputs.tf                   # Terraform outputs
│   ├── security-group.tf            # Security groups configuration
│   ├── ec2.tf                        # EC2 instance and SSH key pair
│   ├── s3.tf                         # S3 bucket configuration
│   ├── cloudwatch.tf                 # CloudWatch logs and metrics configuration
│   ├── iam.tf                        # IAM roles and policies
│   ├── user-data.sh                  # EC2 user data script
├── docker/                          # Docker configurations
│   ├── Dockerfile                    # Production Dockerfile
│   ├── docker-compose.test.yml       # Docker Compose file for testing
│   ├── index.html                    # Static HTML file served by Nginx
├── tests/                            # Automated tests
│   ├── test_app.py                   # Test script to verify Nginx is running
├── scripts/                          # Automation scripts
│   ├── generate-iam-policy.sh        # Script to generate IAM policy dynamically
├── .gitignore                        # Ignored files configuration
├── requirements.txt                  # Dependencies for testing
├── README.md                         # Project documentation
```

## **Infrastructure Setup (AWS)**
The AWS infrastructure is provisioned using **Terraform** and includes:
- **EC2 Instance (t2.micro)** for hosting the application.
- **Security Groups** to allow HTTP (80) and SSH (22) traffic.
- **IAM Role & Policies** for ECR and CloudWatch permissions.
- **Key Pair** for secure SSH authentication.
- **CloudWatch Log Group** for storing application logs.
- **CloudWatch Agent** for collecting system metrics.

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

## **Monitoring & Observability**
This project uses Amazon CloudWatch for log management and system metrics monitoring.

### **CloudWatch Logs**
- Nginx access logs are sent to CloudWatch Log Group: nginx-access-logs.
- The CloudWatch Agent is installed on the EC2 instance to stream logs.

To check logs in AWS Console:
1. Navigate to CloudWatch → Logs.
2. Locate the Log Group: nginx-access-logs.
3. Click on the log stream associated with the EC2 instance.

To check logs via CLI:

```bash
aws logs tail nginx-access-logs --follow --region us-east-1
   ```

### **CloudWatch Metrics**
The CloudWatch Agent collects and publishes metrics for:
- CPU Utilization
- Memory Usage
- Disk Space
- Metrics are sent to the CWAagent namespace in CloudWatch.

To view metrics:
1. Go to CloudWatch → Metrics.
2. Search for CWAgent.
3. Select InstanceId dimension to visualize metrics for the EC2 instance.

To fetch metrics via CLI:

```bash
aws cloudwatch list-metrics --namespace CWAgent --region us-east-1
   ```
### **Restart CloudWatch Agent**
If needed, restart the CloudWatch Agent inside the EC2 instance:

```bash
sudo systemctl restart amazon-cloudwatch-agent
```
<img width="1435" alt="Captura de Tela 2025-03-19 às 18 33 05" src="https://github.com/user-attachments/assets/097bf029-c87c-4663-bfa1-9d6b2fda21c2" />

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
