# generate inventory file for Ansible
resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/templates/hosts.tpl",
    {
      jenkins_ip = var.jenkins_ip_var
      jenkins_user = var.jenkins_user_var
      jenkins_pass = var.jenkins_pass_var

      gitlab_ip = var.gitlab_ip_var
      gitlab_user = var.gitlab_user_var
      gitlab_pass = var.gitlab_pass_var
    }
  )
  filename = "../configuration/hosts.cfg"
}

# generate inventory file for Ansible
resource "local_file" "var_cfg" {
  content = templatefile("${path.module}/templates/ansible-var.tpl",
    {
      jenkins_dns = var.jenkins_dns_var
      gitlab_dns = var.gitlab_dns_var
    }
  )
  filename = "../configuration/vars.yaml"
}