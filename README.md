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



### How to manage?
Use `manage.sh`
```
./manage.sh -h
manage.sh [-v] [-q] [-h] [-i] [-j] [-g] [-d] - script that manage creating and configuring infra for Jenkkins and Gitlab
Where:
    -i  Manage infra creating or destroying
    example:
        manage.sh -i create
        manage.sh -i destroy
    -j  Configure jenkins
    -g  Configure gitlab
    -d Configure demo
    -h  show this help message
    -q  quiet mode, doesnt print any info/error messages
    example:
        manage.sh -jgd
```
To create/destroy infra
```
cd infra
../manage.sh -i create
```
To configure Jenkins/Gitlab(in project root dir)
```
./manage.sh -jg
```