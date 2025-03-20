

#!/bin/bash

# AWS EC2 Instance Details
EC2_USER="ec2-user"
EC2_HOST="your-ec2-instance-ip"
APP_NAME="my-app"

echo "Deploying to AWS EC2..."

# Copy built Docker image to EC2
scp -i your-key.pem docker-compose.yml $EC2_USER@$EC2_HOST:/home/ec2-user/

# SSH into EC2 and start the app
ssh -i your-key.pem $EC2_USER@$EC2_HOST << EOF
    docker-compose down
    docker-compose up -d --build
EOF

echo "Deployment Complete!"

