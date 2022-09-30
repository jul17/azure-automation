# azure-automation

## Tasks

1. Spin up two VM's in any cloud, first will serve as VCS system (gitlab or bitbucket), second - Jenkins server

2. Create Jenkins job that will periodically scan VCS for new repositories. If there is new repository created within last 15 minutes and this repo contains Jenkinsfile - new Jenkins job must be created for that Jenkinsfile automatically.



> Infrastructure provisioning must be automated.

> Configuration management of Jenkins and git servers must be automated as well.



### Desired outcome:

- Terraform / ARM / Bicep codebase for infrastructure provisioning

- Configuration management codebase created using any tool (Ansible for example)

- A demo that highlights infrastructure provisioning and configuration management process.

- Another demo that shows Jenkins pipeline and creation of new job after new repository created.