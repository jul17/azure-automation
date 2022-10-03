#!/bin/bash

set -e
RED="\033[1;31m"
GREEN="\033[1;32m"
NC="\033[0m"
# INFRA="none"
JENKINS=0
GITLAB=0
VERBOSITY=1
DEMO=0

INFRA_PATH="infra"
SELF_NAME=$(basename "$0")
ANSIBLE_PATH="configuration"
JENKINS_PLAYBOOK="jenkins-set-up-playbook.yaml"
GITLAB_PLAYBOOK="gitlab-set-up-playbook.yaml"
HOSTS_FILE="hosts.cfg"
J_DEMO_PLAYBOOK="demo-playbook.yaml"
G_DEMO_PLAYBOOK="gitlab-demo-playbook.yaml"

error() {
    if [[ "${VERBOSITY}" -gt 0 ]]; then
        echo -e "${RED}[ERROR] $1${NC}"; exit 1
    fi
}

info() {
    if [[ "${VERBOSITY}" -gt 0 ]]; then
        echo -e "${GREEN}[INFO] $1${NC}"
    fi
}

cmd() {
   local cmd="${1}"
   eval "${cmd}"
#    if [[ $? -gt 0 ]]; then
#         error "${cmd} execution failed"
#    else
#        info "${cmd} execution succeed"
#    fi
}

USAGE() {
    cat << EOF
${SELF_NAME}[-q] [-h] [-i] [-j] [-g] [-d] - script that manage creating and configuring infra for Jenkkins and Gitlab
Where:
    -i  Manage infra creating or destroying
    example:
        ${SELF_NAME} -i create
        ${SELF_NAME} -i destroy
    -j  Configure jenkins
    -g  Configure gitlab
    -d Configure demo
    -h  show this help message
    -q  quiet mode, doesnt print any info/error messages
    example:
        ${SELF_NAME} -jgd
EOF
}

# cmd_in_dir() {
#     local path=${1}
#     local cmd="${2}"
#     echo "$cmd"
#     ( cd "${path}" ; info "($(pwd)) ${cmd}" && eval "${cmd}")
# }

input_user(){
    local command=${1}
    read -p "\nIf apply plan input [yes] " apply
    if [[ ${apply} == "yes" ]]; then
        cmd "${command}"
    fi
}

infra() {
    local option=$1
    if [[ ${option} == "create" ]]; then
        info "Infra Plan"
        cmd "terraform plan -out main.tfplan"
        input_user "terraform apply \"main.tfplan\""
    elif [[ ${option} == "destroy" ]]; then
        info "Infa Plan to Destroy"
        cmd "terraform plan -destroy -out main.destroy.tfplan"
        input_user "terraform apply main.destroy.tfplan"
    else
        USAGE >&2; error "No option [${option}] for creating infra."
    fi
}

jenkins_configure() {
    info "Start Jenkins servise"
    cmd "ansible-playbook -i ${ANSIBLE_PATH}/${HOSTS_FILE} ${ANSIBLE_PATH}/${JENKINS_PLAYBOOK}"
}

gitlab_configure() {
    info "Start GITLAB servise"
    cmd "ansible-playbook -i ${ANSIBLE_PATH}/${HOSTS_FILE} ${ANSIBLE_PATH}/${GITLAB_PLAYBOOK}"
}

demo_configure() {
    info "Configure DEMO"
    info "JENKINS DEMO"
    cmd "ansible-playbook -i ${ANSIBLE_PATH}/${HOSTS_FILE} ${ANSIBLE_PATH}/demo/${G_DEMO_PLAYBOOK}"
    cmd "ansible-playbook -i ${ANSIBLE_PATH}/${HOSTS_FILE} ${ANSIBLE_PATH}/demo/${J_DEMO_PLAYBOOK}"

}

while getopts ":xhqi:jgd" opt; do
    case ${opt} in
        x) set -x ;;
        h) USAGE; exit 0 ;;
        q) VERBOSITY=0 ;;
        i) INFRA=${OPTARG} ;;
        j) JENKINS=1 ;;
        g) GITLAB=1 ;;
        d) DEMO=1 ;;
        :)
            USAGE >&2; error "Option -${error_option} requires an argument." >&2 ;;
        *)
            USAGE
            error "Provided option not found" >&2 ;;

    esac
done
if [[ $# -eq 0 ]]; then
    error "No arguments supplied"
fi

main() {
    if [[ -n ${INFRA} ]]; then
        infra ${INFRA}
    fi
    if [[ ${JENKINS} -eq 1 ]]; then
        jenkins_configure
    fi
    if [[ ${GITLAB} -eq 1 ]]; then
        gitlab_configure
    fi
    if [[ ${DEMO} -eq 1 ]]; then
        demo_configure
    fi

}

main
