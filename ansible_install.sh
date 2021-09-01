#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
ANSIBLE_DIR="${SCRIPT_DIR}/ansible"

AWS_PROFILE=roudy-super-dev

pushd .
cd ${ANSIBLE_DIR}

ansible-playbook ./test_playbook.yml -e "@vars/main.yml" -e "@vars/install.yml"

popd
