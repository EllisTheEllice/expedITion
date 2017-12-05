# Expedition Demo

The is a simple demo workflow to show how Infrastructure as Code and Continous Deployment (CD) can look like.
This demo uses terraform to spin up the following architecture:

![alt text](https://github.com/simibimi/expedition/blob/master/docs/architecture.png "Architecture")


## How to set up the environment

The following description assumes you have a working terraform installation in place.
See [here](https://www.terraform.io/intro/getting-started/install.html) if you need to install terraform first.
Once terraform is in place, you need to create a terraform.tfvars file within the projects terraform folder.

The project already contains a terraform.example file which you can use as a starting point. Just rename the file to terraform.tfvars and put in your credentials.
Now you´re ready to start the infrastructure provisioning:

```
# Navigate to the projects terraform folder
cd <projectpath>/terraform
# Call terraform apply to create the infrastructure
terraform apply
```

The scripts output will look similar to this:

```

web-server-ip:
jenkins-ip: 
```

You can use the web-server-ip to connect to the Web server and the jenkins-ip to connect to the Jenkins Build server.
The Jenkins credentials are:
*username: username*
*password: bitnami*