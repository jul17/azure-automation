variable "ansible_path" {
  default     = "../configuration"
  description = "Ansible path"
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