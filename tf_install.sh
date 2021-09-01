#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
TERRAFORM_DIR="${SCRIPT_DIR}/tf"

# TODO: verify whether this is needed
# profile to use
AWS_PROFILE=roudy-super-dev

# ssh keys for bastion host
PUB_KEY_PATH=/home/roudy/.ssh/id_rsa.pub
PRIV_KEY_PATH=/home/roudy/.ssh/id_rsa

# will be fed to terraform apply
TERRAFORM_PLAN="plan.tfplan"

pushd .
cd ${TERRAFORM_DIR}

# plan and apply terraform, spins up resources
terraform plan -out ${TERRAFORM_PLAN}
terraform apply --auto-approve ${TERRAFORM_PLAN}

# TODO: key mgmt tech debt for prod readiness
# copy ssh keys to bastion host, this enables access to cluster nodes from bastion.
# public ssh keys should be copied to the cluster nodes via aws_key_pair in tf files.
BASTION_DNS = $(terraform output -raw bastion_public_dns)
scp ${PUB_KEY_PATH} ubuntu@${BASTION_DNS}:/home/ubuntu/.ssh/id_rsa.pub
scp ${PRIV_KEY_PATH} ubuntu@${BASTION_DNS}:/home/ubuntu/.ssh/id_rsa

# update kubectl config to enable access to new k8s cluster
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)

popd
