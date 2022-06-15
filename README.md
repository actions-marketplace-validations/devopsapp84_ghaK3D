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
🤔 Your repo where action want run must contains k3d directory with this 3 files **(k3d/{small/medium/big}.yaml)**.
    Otherwise action will fail!

## Sample output
```console
Run devopsapp84/ghaK3D@v0.0.1-beta
Run actions/checkout@v3
Syncing repository: procter-gamble/vcluster-demo
Getting Git version info
Temporarily overriding HOME='/home/runner/work/_temp/686bc08a-3dd5-4f97-ae49-5659a370e7c6' before making global git config changes
Adding repository directory to the temporary git global config as a safe directory
/usr/bin/git config --global --add safe.directory /home/runner/work/vcluster-demo/vcluster-demo
Deleting the contents of '/home/runner/work/vcluster-demo/vcluster-demo'
Initializing the repository
Disabling automatic garbage collection
Setting up auth
Fetching the repository
Determining the checkout info
Checking out the ref
/usr/bin/git log -1 --format='%H'
'5691e2c5f0994151fea3073374ba54cceaeb5b9e'
Run /home/runner/work/_actions/devopsapp84/ghaK3D/v0.0.1-beta/bin/run.sh -c small
🆗 No k3d cli present installing...
Preparing to install k3d into /usr/local/bin
k3d installed into /usr/local/bin/k3d
Run 'k3d --help' to see what you can do with it.
🚫 kubectl cli was previously installed...
🔥 Creating Kubernetes Cluster: small
✅ Cluster: small sucessfully created
Run /home/runner/work/_actions/devopsapp84/ghaK3D/v0.0.1-beta/bin/run.sh -l small
👍 Cluster: small exist!
---------------------------------------------
NAME    SERVERS   AGENTS   LOADBALANCER
small   1/1       1/1      true
---------------------------------------------
```
