variable "do_token" {}

variable "ssh_pubkey" {
    default = "~/.ssh/local.pub"
}

variable "ssh_privkey" {
    default = "~/.ssh/local"
}

variable "user_data" {
    default = "./user-data.yml"
}

variable "deploy_key" {
  default = "{\"title\": \"do-maestro-demo\", \"key\": \"$(cat /etc/maestrod/creds.d/id_rsa.pub)\", \"read_only\": \"true\"}"
}

provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_ssh_key" "default" {
  name       = "personal-mbp"
  public_key = "${file("${var.ssh_pubkey}")}"
}

resource "digitalocean_droplet" "maestro-k8s" {
  name               = "maestro-k8s"
  region             = "nyc3"
  size               = "48gb"
  image              = "coreos-stable"
  # private_networking = true
  ssh_keys           = ["${digitalocean_ssh_key.default.id}"]
  user_data          = "${file("${var.user_data}")}"

  provisioner "file" {
    source      = "kube-configs/"
    destination = "/etc/k8s/"

    connection {
      type        = "ssh"
      user        = "christian"
      private_key = "${file("${var.ssh_privkey}")}"
    }
  }

  provisioner "file" {
    source      = "maestrod/"
    destination = "/etc/maestrod/"

    connection {
      type        = "ssh"
      user        = "christian"
      private_key = "${file("${var.ssh_privkey}")}"
    }
  }

  provisioner "file" {
    source      = "nginx/"
    destination = "/opt/nginx/"

    connection {
      type        = "ssh"
      user        = "christian"
      private_key = "${file("${var.ssh_privkey}")}"
    }
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "christian"
      private_key = "${file("${var.ssh_privkey}")}"
    }

    inline = [
      "ssh-keygen ssh-keygen -f /etc/maestrod/creds.d/id_rsa -t rsa -b 4096 -C 'do-maestro-demo' -N ''",
      "curl -XPOST -H 'Content-Type: application/json' -d ${var.deploy_key}  https://api.github.com/repos/cpg1111/maestro/keys",
    ]
  }
}
