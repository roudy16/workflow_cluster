#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
TERRAFORM_DIR="${SCRIPT_DIR}/tf"

AWS_PROFILE=roudy-super-dev

TERRAFORM_PLAN="plan.tfplan"

pushd .
cd ${TERRAFORM_DIR}

terraform plan -destroy -out ${TERRAFORM_PLAN}
terraform apply -destroy --auto-approve ${TERRAFORM_PLAN}

popd
