# ghaK3D
Github Action K3d Cluster

## Inputs
cluster_name: 
Default: small

cluster_version:

Default: latest

name
cluster name.

Default: mycluster

skipClusterCreation
If "true", the action will not create a cluster, just acquire the tools.

Default: false

ingressPort
If it is not 0, ingress will be exposed to the specified port.

Default: 0

agents
If it is not 0, specified number of agents will be created.

Default: 0

options
extra options that will passed to k3d cluster create command.

Default: ""

Examples
To create a single node cluster,

on: push
jobs:
  setup-k3d:
    runs-on: ubuntu-latest
    steps:
      - uses: rinx/setup-k3d@v0.0.2
      - name: Get cluster info
        run: |
          kubectl cluster-info
          kubectl get pods -n kube-system
          kubectl get nodes
          echo "current-context:" $(kubectl config current-context)
To create a cluster with multi agents,

on: push
jobs:
  setup-k3d:
    runs-on: ubuntu-latest
    steps:
      - uses: rinx/setup-k3d@v0.0.2
        with:
          agents: 3
      - name: Get cluster info
        run: |
          kubectl cluster-info
          kubectl get pods -n kube-system
          kubectl get nodes
          echo "current-context:" $(kubectl config current-context)
To create a cluster with exposed ingress,

on: push
jobs:
  setup-k3d:
    runs-on: ubuntu-latest
    steps:
      - uses: rinx/setup-k3d@v0.0.2
        with:
          ingressPort: 8081
      - name: Get cluster info
        run: |
          kubectl cluster-info
          kubectl get pods -n kube-system
          kubectl get nodes
          echo "current-context:" $(kubectl config current-context)
