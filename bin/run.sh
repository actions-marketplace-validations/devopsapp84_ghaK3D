#!/bin/bash
# WHEN:        WHO:           WHAT:
# 04/08/2022   Janusz Kujawa  Created initial parts of script.
# 04/22/2022   Janusz Kujawa  Added invalid_option function
# 14/06/2022   Janusz Kujawa  Adjust script to use within GH actions

### Variables
CLUSTER_NAME="${2:-"small"}"
k3d_log="/tmp/$CLUSTER_NAME-create.log"

usage() {                                     
   echo
   echo "Syntax: $0  [-h|c|d|l]"
   echo "options:"
   echo "h          Print help available options"
   echo "c          create k3d cluster"
   echo "d          delete k3d cluster"
   echo "l          list k3d cluster"
   echo
   exit 0
}

invalid_option() {
  echo "Invalid or no option given!"
  usage
  exit 1
}

progress_k3d_cluster() {
  while [ 1 ]; do
      k3d_progress=$(grep -i "successfully" $k3d_log)
      if [ -z "$k3d_progress" ]; then
        sleep 1
      else
        if grep -q "deleted" "$k3d_log"; then
          printf "%b" "\n\U2705 Cluster: \e[1;34m$CLUSTER_NAME\e[0m sucessfully deleted\n"
        elif grep -q "created" "$k3d_log"; then
          printf "%b" "\n\U2705 Cluster: \e[1;34m$CLUSTER_NAME\e[0m sucessfully created\n"
        else
          printf "%b" "\n\U26A1 Unsupported!\n"
        fi
        truncate -s 0 $k3d_log
        exit
      fi
  done
}

function install_clis {
  # k3d
  if ! command -v k3d &> /dev/null
  then
    printf "%b" "\U1F197 No k3d cli present installing...\n"
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
  else
    printf "%b" "\U1F6AB k3d cli was previously installed...\n"
  fi
  
  # kubectl
  if ! command -v kubectl &> /dev/null
  then
    printf "%b" "\U1F197 No kubectl cli present installing...\n"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
    chmod +x kubectl
    mkdir -p ~/.local/bin
    mv ./kubectl ~/.local/bin/kubectl
    kubectl version
  else
    printf "%b" "\U1F6AB kubectl cli was previously installed...\n"
  fi

}

function create_k3d_cluster {
  # Create cluster if des not exist
  if [[ $(k3d cluster list --no-headers | grep $CLUSTER_NAME) ]]; then
    printf "%b" "\U26D4 Cluster: \e[1;34m$CLUSTER_NAME\e[0m already exist!\n"
    exit
  elif [ -f "k3d/${CLUSTER_NAME}.yaml" ]; then
    printf "%b" "\U1F525 Creating Kubernetes Cluster: \e[1;34m$CLUSTER_NAME\e[0m "
    k3d cluster create ${CLUSTER_NAME} -c k3d/${CLUSTER_NAME}.yaml >> $k3d_log &
  else
    printf "%b" "\U1F440 Kubernetes cluster config: \e[1;34m${CLUSTER_NAME}.yaml\e[0m does not exist! Please check k3d dir! \n"
    exit 1
  fi
}

function delete_k3d_cluster {
  # Delete cluster if still exist
  if [[ $(k3d cluster list --no-headers | grep $CLUSTER_NAME) ]]; then
    printf "%b" "\U26A1 Cluster: \e[1;34m$CLUSTER_NAME\e[0m exists and will be deleted "
    k3d cluster delete $CLUTER_NAME >> $k3d_log 2>&1 &
  else
    printf "%b" "\U1F631 Cluster: \e[1;34m$CLUSTER_NAME\e[0m does not exist no action taken...\n"
    exit
  fi
}

function list_k3d_cluster {
  status=$(k3d cluster list --no-headers | grep $CLUSTER_NAME)
  if [[ $status ]]; then
    printf "%b" "\U1F44D Cluster: \e[1;34m$CLUSTER_NAME\e[0m exist!\n"
    printf "%b" "\e[1;32m---------------------------------------------\e[0m\n"
    k3d cluster list $CLUSTER_NAME
    printf "%b" "\e[1;32m---------------------------------------------\e[0m\n"
  else
    printf "%b" "\U274C Cluster: \e[1;34m$CLUSTER_NAME\e[0m does not exist!\n"
  
    
  fi
}

# check if argument given
if [[ ! $@ =~ ^\-.+ ]]
  then
    invalid_option
  fi

while getopts "hcdl" options; do            
                                                                                        
  case $options in                          
    h)
      usage                                        
      ;;
    c)
      install_clis
      create_k3d_cluster
      progress_k3d_cluster
      ;;
    d)
      delete_k3d_cluster
      progress_k3d_cluster
      ;;
    l)
      list_k3d_cluster
      ;;
    *)                                        
      invalid_option                        
      ;;
  esac
done