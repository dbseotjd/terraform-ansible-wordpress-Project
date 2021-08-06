# terraform-ansible-wordpress

## Wordpress Deployment Project using Ansible , Terraform , Aws

**프로젝트의 목적**          
Ansible 에서의 playbook을 통한 배포 다음으로 그것을 인프라에 적용시키는 terrform을 통한 AWS 인프라 구성관리를 위함          

* requirements :             
terraform 설치
```
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

sudo apt install terraform
```
aws account 
```
aws configure # access key와 secret key를 지정
```

* How to launch         
```
git clone https://github.com/HEONPOLI/terraform-ansible-wordpress.git
cd tf_ansible_roles_one_instance
terraform init # 백엔드 구성을 위함 , aws profile 은 default | region 은 서울로 된 상태
terraform apply -auto-approve
```

* Variables 확인         
```
cat variable.tf # 포트값을 변경하면 보안그룹에도 적용되어 서비스포트를 오픈
```

```bash
.
├── deploy_wordpress_db_roles.yaml
├── group_vars
│   └── all.yaml
├── inventory.ini
├── main.tf
├── my_sshkey
├── my_sshkey.pub
├── output.tf
├── provider.tf
├── roles
│   ├── database
│   │   ├── handlers
│   │   │   └── main.yaml
│   │   ├── tasks
│   │   │   ├── Debian
│   │   │   │   └── install_debian.yaml
│   │   │   ├── RedHat
│   │   │   │   └── install_redhat.yaml
│   │   │   └── main.yaml
│   │   └── vars
│   │       └── main.yaml
│   └── wordpress
│       ├── handlers
│       │   └── main.yaml
│       ├── tasks
│       │   ├── fetch-config
│       │   │   ├── get_wp.yaml
│       │   │   └── sync_config.yaml
│       │   ├── install-confchange
│       │   │   ├── changePort_deb.yaml
│       │   │   ├── changePort_red.yaml
│       │   │   ├── install_deb.yaml
│       │   │   └── install_red.yaml
│       │   └── main.yaml
│       ├── templates
│       │   ├── httpd.conf.j2
│       │   ├── ports.conf.j2
│       │   └── wp-config.php.j2
│       └── vars
│           └── main.yaml
├── security-group.tf
├── terraform.tfstate
├── terraform.tfstate.backup
└── variable.tf
```
프로젝트의 구조는 위와같다. 

* 생성되는 AWS 리소스 
aws_security_group      

aws_key_pair

aws_instance


