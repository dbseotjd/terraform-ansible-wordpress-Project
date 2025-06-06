# terraform-ansible-wordpress
**프로젝트의 목적**          
Ansible 에서의 playbook을 통한 배포 다음으로 그것을 인프라에 적용시키는 terrform을 통한 AWS 인프라 구성관리를 위함            

* requirements :             
1. ansible 설치        
provisioner의 local-exec 기능을 사용하여 진행하므로, 로컬에서는 ansible 구동환경이 필요하다.       
```
sudo apt update
sudo apt install -y software-properties-common
sudo apt-add-repository -y -u ppa:ansible/ansible
sudo apt install -y ansible

#쉘 자동완성
sudo apt install -y python3-argcomplete
sudo activate-gloval-python-argcomplete3

#문법 체크
sudo apt install -y ansibel-lint
exec bash
```

2. terraform 설치
```
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

sudo apt install terraform
```
aws account 
```
aws configure # access key와 secret key를 지정
```
## tf_ansible_roles_one_instance
Wordpress Deployment Project using Ansible , Terraform , Aws

* How to launch         
```
git clone https://github.com/HEONPOLI/terraform-ansible-wordpress.git
cd tf_ansible_roles_one_instance
terraform init # 백엔드 구성을 위함 , aws profile 은 default | region 은 서울로 된 상태
terraform apply -auto-approve
```

* 주요 Variables 확인         
```
cat variable.tf # 포트값을 변경하면 보안그룹에도 적용되어 서비스포트를 오픈
```

* 프로젝트 구조
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

* 생성되는 AWS 리소스 

aws_security_group # ssh 접속, 서비스 포트 오픈등을 위한 보안그룹 생성           

aws_key_pair # ssh 접속을 위한 인스턴스에 키제공             

aws_instance # 워드프레스와 mysql을 manual로 제공할 인스턴스 생성             

## tf_ansible_roles_RDS
Wordpress Deployment Project using Ansible , Terraform , Aws -> RDS

* How to launch      
```
git clone https://github.com/HEONPOLI/terraform-ansible-wordpress.git
cd tf_ansible_roles_RDS
terraform init # 백엔드 구성을 위함 , aws profile 은 default | region 은 서울로 된 상태
terraform apply -auto-approve
```

* 주요 Variables 확인         
```
cat variable.tf # 포트값을 변경하면 보안그룹에도 적용되어 서비스포트를 오픈
cat group_vars/all.yaml # RDS에서 생성된 데이터베이스, 유저, 호스트(엔드포인트) 등을 변수화하여 인스턴스에 제공
cat roles/wordpress/vars/main.yaml # group_vars 의 변수들을 이중참조
```

* 프로젝트 구조
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
* 생성되는 AWS 리소스           

aws_security_group  # RDS 3306 포트로 접근을 위한 보안그룹, 인스턴스 -> RDS로의 접근을 위해 3306 포트를 허용하는 보안그룹 생성

aws_key_pair # ssh 접속을 위한 키페어

aws_instance # ansible playbook을 통해 워드프레스가 배포될 인스턴스 생성         

aws_db_instance # --> RDS 워드프레스의 데이터베이스 역할을 하는 RDS 생성(mysql En in )       


