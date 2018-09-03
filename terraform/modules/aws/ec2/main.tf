variable "apiid" {}
variable "eip_alloc_id" {}

resource "aws_instance" "web" {
  ami           = "ami-add175d4"
  instance_type = "t2.micro"
  associate_public_ip_address=true
  key_name = "jenkins"

  connection {
        user = "ubuntu"
        private_key = "${file("${path.module}/jenkins.pem")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update > /tmp/userdata.log",
      "sudo apt-get install -y apache2 >> /tmp/userdata.log",
    ] 
  }

  tags {
    Name = "web"
  }
}

resource "aws_instance" "jenkins" {
  depends_on    = ["aws_instance.web"]
  ami           = "ami-01459f78173d42da1"
  instance_type = "t2.micro"
  associate_public_ip_address=true
  key_name = "jenkins"

  connection {
        user = "bitnami"
        private_key = "${file("${path.module}/jenkins.pem")}"
  }

  provisioner "file" {
    source      = "${path.module}/jenkins.pem"
    destination = "/tmp/jenkins.pem"
  }

    provisioner "remote-exec" {
    inline = [
      //"sudo mkdir /home/tomcat/.ssh",
      //"sudo mv /tmp/jenkins.pem /home/tomcat/.ssh/jenkins.pem",
      //"sudo chown -R tomcat:tomcat /home/tomcat/.ssh",
      //"sudo chmod 400 /home/tomcat/.ssh/jenkins.pem",
      "echo '${var.apiid}' > /tmp/apiid",
      "echo '${aws_instance.web.public_dns}' > /tmp/dns"
    ]
  }

  tags {
    Name = "jenkins"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = "${aws_instance.jenkins.id}"
  allocation_id = "${var.eip_alloc_id}"
}

output "web-server-ip" {
  value = "${aws_instance.web.public_ip}"
}

output "jenkins-ip" {
  #value = "${aws_instance.jenkins.public_ip}"
  value = "52.214.45.163"
}