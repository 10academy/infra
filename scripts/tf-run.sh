#!/bin/sh

# vars + defaults
ACTION_PLAN=plan
ACTION_APPLY=apply
EXTRA_PARAMS=""

# params
ACTION=${1:-${ACTION_PLAN}}
TARGET=${2:-global}
PROVIDER=${3:-aws}

# get tf path + required files
DIR="$(cd "$(dirname "$0")" && pwd -P)"
TF_PATH=${DIR}/../terraform/providers/${PROVIDER}/${TARGET}
TF_FILE=${TF_PATH}/${TARGET}.tf
SECRET_VARS_FILE_NAME=secret.tfvars
SECRET_VARS_FILE=${TF_PATH}/${SECRET_VARS_FILE_NAME}
TF_PLAN_FILE="tf.plan"

# check tf path + tf file exists before proceeding
if [ ! -d ${TF_PATH} ] || [ ! -f ${TF_FILE} ]; then
    echo "Terraform file specified not found!!!"
    exit;
fi

if [ -f ${SECRET_VARS_FILE} ]; then
   echo "${SECRET_VARS_FILE_NAME} file found and is being loaded..."
   EXTRA_PARAMS+=" -var-file=${SECRET_VARS_FILE_NAME}"
else
   echo "${SECRET_VARS_FILE_NAME} file NOT found so will NOT be loaded!!!\n"
fi

if [ "${ACTION}" == "${ACTION_PLAN}" ]; then
    EXTRA_PARAMS+=" -out=${TF_PLAN_FILE}"
fi

if [ "${ACTION}" == "${ACTION_APPLY}" ]; then
    EXTRA_PARAMS=" ${TF_PLAN_FILE}"
fi

# run tf cmd
cd ${TF_PATH} && terraform get && terraform init && terraform ${ACTION} ${EXTRA_PARAMS}
