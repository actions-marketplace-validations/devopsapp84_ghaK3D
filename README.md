# ghaK3D
Github Action K3d Cluster

## Mission
Create github action that will suit 3 types of cluster depends on sizing:

```console
small:  1 x master + 1 x worker config=./conf/small.yaml
medium: 1 x master + 3 x worker config=./conf/medium.yaml
big:    3 x master + 3 x worker config=./conf/big.yaml
```

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