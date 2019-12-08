#!/bin/bash

SSH_KEY_TO_ADD="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBJuqE5bnBRdjRt7bJ9JO6HrUfwc/QK0WSoq1uXaAEkjju41MafcRD1ARNOH3Ifztyuq73PMZI2psApTIaoYq1Lua5WBSdK5ESlyb4kq2JmMuR7vjnWeSNshCnnnClPiEOZufwq741Q/a3RmVdVW8M1yrgifTXp8ZkAzuUrncQM9Nr7MkxVibVO9AAV4mMp69+MjnXn90LeT4f5aYKqBVCFDnPi7zKE/N/zYJf95ftdp+TAu/UJ/uvvLc7VdxYF8k9ceqXrMhfyqRD/KzPp70qLXkgsoX5ZgPi2pRwHtKYQb6P4IqgLOWr82QPXsRgorUeU+6TxTEj8/hjlpzLZP/h"

if [[ "${SSH_KEY_TO_ADD}" == "" ]]; then
  echo "Error: no key specified to add, delete and run again"
fi

MAPPED_USER_HOME="/tmp/user"
MAPPED_USER_SSH_FOLDER="${MAPPED_USER_HOME}/.ssh"
AUTH_KEYS_FILE="${MAPPED_USER_SSH_FOLDER}/authorized_keys"

USE_UID=$(stat -c '%u' ${MAPPED_USER_HOME})
USE_GID=$(stat -c '%g' ${MAPPED_USER_HOME})

if [ ! -d  ${MAPPED_USER_SSH_FOLDER} ]; then
  echo ".ssh folder doesn't exist, creating it."
  gosu ${USE_UID}:${USE_GID} mkdir ${MAPPED_USER_SSH_FOLDER}
  gosu ${USE_UID}:${USE_GID} chmod 700 ${MAPPED_USER_SSH_FOLDER}
fi

if [ ! -f  ${AUTH_KEYS_FILE} ]; then
  echo "authorized_keys file doesn't exist, creating it"
  gosu ${USE_UID}:${USE_GID} touch ${AUTH_KEYS_FILE}
  gosu ${USE_UID}:${USE_GID} chmod 644 ${AUTH_KEYS_FILE}
fi

grep "${SSH_KEY_TO_ADD}" ${AUTH_KEYS_FILE} > /dev/null
if [[ $? -ne 0 ]]; then
  lastchar=$(tail -c 1 ${AUTH_KEYS_FILE})
  if [[ "${lastchar}" != "" ]]; then
    echo "Adding new line character"
    gosu ${USE_UID}:${USE_GID} echo "" >> ${AUTH_KEYS_FILE}
  fi
  echo "Adding SSH key"
  gosu ${USE_UID}:${USE_GID} echo ${SSH_KEY_TO_ADD} >> ${AUTH_KEYS_FILE}
else
  echo "Key already added"
fi
