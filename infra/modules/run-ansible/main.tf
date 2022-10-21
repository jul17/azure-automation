resource "null_resource" "configure_jenkins" {
    provisioner "local-exec" {
      command = "ansible-playbook -i hosts.cfg $JENKINS_PLAYBOOK"

      working_dir = var.ansible_path
      environment = {
        JENKINS_PLAYBOOK = var.jenkins_play
      }
  }
}

resource "null_resource" "configure_gitlab" {
    provisioner "local-exec" {
      command = "ansible-playbook -i hosts.cfg $GITLAB_PLAYBOOK"

      working_dir = var.ansible_path
      environment = {
        GITLAB_PLAYBOOK  = var.scm_play
      }
  }
}