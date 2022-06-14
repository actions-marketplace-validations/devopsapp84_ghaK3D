#!/bin/bash
set -o errexit
set -o pipefail

YELLOW=
CYAN=
RED=
NC=
K3D_URL=https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh
DEFAULT_K3D_VERSION=v5.4.1

#######################
#
#     FUNCTIONS
#
#######################
usage(){
  cat <<EOF
  Usage: $(basename "$0") <COMMAND>
  Commands:
      deploy            deploy custom k3d cluster
  Environment variables:
      deploy
                        CLUSTER_NAME (Required) k3d cluster name.
                        ARGS (Optional) k3d arguments.
                        K3D_VERSION (Optional) k3d version.
EOF
}

panic() {
  (>&2 echo -e " - ${RED}$*${NC}")
  usage
  exit 1
}

deploy(){
    local name=${CLUSTER_NAME}
    local arguments=${ARGS:-}
    local k3dVersion=${K3D_VERSION:-${DEFAULT_K3D_VERSION}}

    if [[ -z "${CLUSTER_NAME}" ]]; then
      panic "CLUSTER_NAME must be set"
    fi

    echo -e "${YELLOW}Downloading ${CYAN}k3d@${k3dVersion} ${NC}see: ${K3D_URL}"
    curl --silent --fail ${K3D_URL} | TAG=${k3dVersion} bash

    echo -e "\existing_network${YELLOW}Deploy cluster ${CYAN}$name ${NC}"
    eval "k3d cluster create $name --wait $arguments"
    wait_for_nodes
}

# waits until all nodes are ready
wait_for_nodes(){
  echo -e "${YELLOW}wait until all agents are ready${NC}"
  while :
  do
    readyNodes=1
    statusList=$(kubectl get nodes --no-headers | awk '{ print $2}')
    # shellcheck disable=SC2162
    while read status
    do
      if [ "$status" == "NotReady" ] || [ "$status" == "" ]
      then
        readyNodes=0
        break
      fi
    done <<< "$(echo -e  "$statusList")"
    # all nodes are ready; exit
    if [[ $readyNodes == 1 ]]
    then
      break
    fi
    sleep 1
  done
}
#######################
#
#     GUARDS SECTION
#
#######################
if [[ "$#" -lt 1 ]]; then
  usage
  exit 1
fi
if [[ -z "${NO_COLOR}" ]]; then
      YELLOW="\033[0;33m"
      CYAN="\033[1;36m"
      NC="\033[0m"
      RED="\033[0;91m"
fi

#######################
#
#     COMMANDS
#
#######################
case "$1" in
    "deploy")
       deploy
    ;;
#    "<put new command here>")
#       command_handler
#    ;;
      *)
  usage
  exit 0
  ;;
esac
