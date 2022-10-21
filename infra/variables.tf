variable "resource_group_location" {
  default     = "West Europe"
  description = "Location of the resource group."
}

# ANSIBLE_PATH="configuration"
# JENKINS_PLAYBOOK="jenkins-set-up-playbook.yaml"
# GITLAB_PLAYBOOK="gitlab-set-up-playbook.yaml"
# HOSTS_FILE="hosts.cfg"
# J_DEMO_PLAYBOOK="demo-playbook.yaml"
# G_DEMO_PLAYBOOK="gitlab-demo-playbook.yaml"

variable "ansible_path" {
  default     = "../configuration"
  description = "Location of the resource group."
}

variable "jenkins_play" {
  default = "jenkins-set-up-playbook.yaml"
}

variable "scm_play" {
  default = "gitlab-set-up-playbook.yaml"
}

variable "hosts_file" {
  default = "hosts.cfg"
}