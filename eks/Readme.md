My Account AWS is Free Tiers

First Method:

Create EKS Cluster
```
eksctl create cluster --name=EKS-1 --region=us-east-1 --zones=us-east-1a,us-east-1b --without-nodegroup
```
Enable OpenID Connect
```
eksctl utils associate-iam-oidc-provider --region us-east-1 --cluster EKS-1 --approve
```
Create Node Group
```
eksctl create nodegroup --cluster EKS-1 --region us-east-1 --name nodesgr --node-type t3.micro --nodes 2  --nodes-min 1 --nodes-max 3 --node-volume-size 10 --ssh-access --ssh-public-key Key\ Tutorial --managed --asg-access  --external-dns-access --full-ecr-access --appmesh-access --alb-ingress-access
```



```
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: my-low-cost-cluster
  region: us-east-1

nodeGroups:
  - name: worker-spot
    instanceType: t3.micro  # Instance éligible au Free Tier
    desiredCapacity: 2
    minSize: 1
    maxSize: 2
    spot: true  # Utilisation de Spot Instances pour réduire les coûts
    volumeSize: 10  # Réduit la taille du disque EBS pour limiter les coûts
    privateNetworking: true  # Pas de coût d'ELB public
    ssh-public-key: "Key Tutorial"
```
```
eksctl create nodegroup \
  --cluster my-low-cost-cluster \
  --name worker-spot \
  --region us-east-1 \
  --instance-types t3.micro \
  --nodes 1 \
  --nodes-min 1 \
  --nodes-max 2 \
  --spot
```

```
eksctl create cluster -f cluster-config.yaml
```

Delete Cluster

```
eksctl delete cluster --name my-low-cost-cluster
```
