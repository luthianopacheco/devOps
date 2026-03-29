#!/bin/bash
cd /home/ec2-user/app
docker stop devops-flask-app || true
docker rm devops-flask-app || true
docker build -t devops-flask-app .
docker run -d -p 5000:5000 --name devops-flask-app devops-flask-app