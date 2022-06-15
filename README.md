# ghaK3D
Github Action K3d Cluster

## Mission
Create github action that will suit 3 types of cluster depends on sizing:

| name   | master | worker | config file       |
|:-------|:-------|:-------|:------------------|
| small  | 1      | 1      | ./k3d/small.yaml  |   
| medium | 1      | 3      | ./k3d/medium.yaml |  
| big    | 3      | 1      | ./k3d/big.yaml    |  

I used pure limited output with several waits (waiting for k3s core components to be up and running.)

:rocket:
Cluster name should be equal config name for instance when you would like to deploy small cluster you must set intput:

```console
 cluster_name=small
```

## Inputs
cluster_name: 
Default: small

cluster_version:
Default: latest

## Requirements
🤔 Your repo should contains k3d directory with this 3 files (k3d/{small/medium/big}.yaml)