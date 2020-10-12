# terraform-ansible-automation-aws

### Prerequistes

* setup an IAM user for full programatic access to create custom resources using terraform
  [link](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html)
* Create a key in order to refer in the instance.tf and nat.tf files to create EC2 instances
  [link](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)
* Terraform version

```sh
[root@ Terraform-Ansible-Automation-miq]# terraform version
Terraform v0.13.4
```
* Ansible Version
```sh
[root@ Terraform-Ansible-Automation-miq]# ansible --version
ansible 2.7.9
  config file = /etc/ansible/ansible.cfg
  configured module search path = [u'/root/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python2.7/site-packages/ansible
  executable location = /bin/ansible
  python version = 2.7.18 (default, Aug 27 2020, 21:22:52) [GCC 7.3.1 20180712 (Red Hat 7.3.1-9)]
``
* OS used for triggering ansible and terraform scripts

```sh
[root@ Terraform-Ansible-Automation-miq]# cat /etc/*release
NAME="Amazon Linux"
VERSION="2"
ID="amzn"
ID_LIKE="centos rhel fedora"
VERSION_ID="2"
PRETTY_NAME="Amazon Linux 2"
ANSI_COLOR="0;33"
CPE_NAME="cpe:2.3:o:amazon:amazon_linux:2"
HOME_URL="https://amazonlinux.com/"
Amazon Linux release 2 (Karoo)
```
After all the changes are done in the above mentioned files we can run following command which will perform the following actions

* Spin up two EC2 instances one in public subnet and one in private subnet
* One nat instance in order to with elastic IP and route table configured with private subnet, in order to provide internet access 
  to private instance
* VPC with private and public subnet
* A nat instance in public subnet
* A network load balancer to access nginx UI message as "HELLO DOCKER"

```sh
terraform apply --var-file terraform.tfvars
```

* After the infra has been provisioned please update the following details in [/ansible/main.yaml](./ansible/main.yaml) and run the following command

```sh
- name: Inventory
  hosts: private_subnet --> update(1)
  vars:
    - ansible_ssh_user: "example" --> update(2)
    - ansible_ssh_common_args: >
          -o ProxyCommand="ssh -W %h:%p -q {{ ansible_ssh_user }}@{{ bastion_ip }}" \ --> update(3)
          -o ServerAliveInterval=5 \
          -o StrictHostKeyChecking=no
```
```sh
 ansible-playbook -u <user-name> --private-key <private-key> ansible/main.yaml
 ```
 This will setup nginx container with index.html copied and container exposed on port 8080 of the instance, which can be routed through the NAT and finally 
 to network load balancer
