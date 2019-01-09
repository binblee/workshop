# Istio Clusters Ingress/Egress Lab



## Overview

By using Istio ServiceEntry and IngressGateway, we can connect services and applications in two different clusters. In this lab, we will show you how to do it.  We're going to build two kubernetes istio clusters, cluster1 and cluseter2. Applications running cluster1 access to service cluster2 via internal DNS domain name.  

## Create ACK clusters using terraform

### Setup terraform

Use terraform scripts to create two ACK managed clusters, each has three nodes. You can find the script in [tf](tf) directory.

```
$ cd tf
$ export ALICLOUD_ACCESS_KEY="<Your Alicloud Access Key>"
$ export ALICLOUD_SECRET_KEY="<Your Alicloud Secret Key>"
$ terraform init
```



Review variables in [tf/variables.tf](tf/variables.tf) and change to meet you requirements, for example, region, zone and ECS password, or kubernetes cluster name.

```
variable "region" {
  description = "Region to launch resources."
  default = "ap-southeast-1"
}

variable "availability_zone" {
  description = "The available zone to launch ecs instance and other resources."
  default     = "ap-southeast-1a"
}

variable "ecs_password" {
  description = "The password of instance."
  default     = "changeme"
}

variable "cluster_name" {
  default = "cluster"
}
```



You may also want to review and change DNS private zone settings.



```
resource "alicloud_pvtz_zone" "zone" {
    name = "sg.private"
}

resource "alicloud_pvtz_zone_record" "k8s" {
    zone_id = "${alicloud_pvtz_zone.zone.id}"
    resource_record = "placeholder"
    type = "A"
    value = "10.10.10.10"
    ttl="60"
}
```



### Create clusters and DNS private zone

```
$ terraform apply
```

Once it is finished, you will get two Kubernetes clusters, naming based on `${var.cluster_name}` setting. DNS private zone with name `${alicloud_pvtz_zone.zone.name}`



### Optional: remove clusters

```
$ terraform destroy
```



## Setup Istio and gateway domain name

In ACK console, click menu `clusters => cluster name "More" => Deploy Istio`, you will see wizard for deploy latest Istio into your cluster. Check the default settings and click `Deploy istio`.





![](img/istio-1.png)

![](img/istio-2.png)





## Reference

External DNS tutorial: [https://github.com/kubernetes-incubator/external-dns/blob/master/docs/tutorials/alibabacloud.md](https://github.com/kubernetes-incubator/external-dns/blob/master/docs/tutorials/alibabacloud.md)



Alibaba Terraform Provider: [https://www.terraform.io/docs/providers/alicloud/index.html](https://www.terraform.io/docs/providers/alicloud/index.html)



