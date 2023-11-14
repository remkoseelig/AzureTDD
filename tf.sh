#!/bin/bash
set -e

ACTION=$1
LAYER=$2

# Validation
if [[ -z $LAYER ]];
then
    echo "Usage: ./$ACTION.sh LAYER"
    echo 
    echo "Examples:"
    echo "./$ACTION.sh storage"
    exit 1
fi

if [[ ! -d $LAYER ]];
then
    echo "Error: Layer '${LAYER}' does not exist."
    exit 1
fi

if [[ -f $LAYER/config.tfvars ]];
then
    TFCONFIG="-var-file=config.tfvars"
fi

# Terraform init
terraform -chdir=$LAYER init -reconfigure -upgrade

# Execute the terraform command
terraform -chdir=$LAYER $ACTION \
    -compact-warnings \
    $TFCONFIG $3 $4
