# ghaK3D
Github Action K3d Cluster

## Mission
Create github action that will suit 3 types of cluster depends on sizing:

| name   | master | worker | config file        |
|:-------|:-------|:-------|:-------------------|
| small  | 1      | 1      | ./conf/small.yaml  |   
| medium | 1      | 3      | ./conf/medium.yaml |  
| big    | 3      | 1      | ./conf/big.yaml    |  

## Inputs
cluster_name: 
Default: small

cluster_version:
Default: latest