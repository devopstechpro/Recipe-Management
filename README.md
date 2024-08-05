# Recipe Managment

The project has backend java application with mongodb and a frontend nodejs application.


## Local development and testing

Pre-requiste:
- Docker installed

Each microservice BE and FE has a `Dockerfile` which when testing locally can be build using Docker Compose.

Build frontend and backend image using docker compose.

`docker-compose build`

Run frontend and backend image using docker compose.

`docker-compose up`

Kill frontend and backend

`docker-compose down` or on windows/macos/linux `CRTL X` 


## CI/CD

The Github workflow pipeline build and published a Docker image to Amazon ECR. The ECR images are published using semantic-release version.

## Build and deploy ECR image

The Github workflow pipeline depends on two types of Github Repo Environments:

1. `semvar` - This environment stores github token used by semantic-release job. The Github token is created manually from Github Account > Settings > Developer Settings > Tokens (classic) - Grant Read Write permission for Repository.

2. `main` - This environment store secrets credentials like `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`. Create IAM user with CLI access to get access key and secret key.Also grant IAM user permission access to Amazon ECR, Amazon ECS Fargate with CLI access 

Please create environment state above before proceed to next step.


## Deploy image to ECS Fargate (Pending)

Publish semantic release version to ECS task defination to deploy new version of Docker images.