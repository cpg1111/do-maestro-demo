variable "do_token" {}
variable "ssh_pubkey" {}

provider "digitalocean" {
    token = "${var.do_token}"
}

resource "digitalocean_ssh_key" "default" {
    name = "personal-mbp"
    public_key = "${file("${var.ssh_pubkey}")}"
}

resource "digitalocean_droplet" "maestro-k8s" {
    name = "maestro-k8s"
    region = "nyc2"
    size = "48gb"
    image = "coreos-1122.3.0-stable"
    private_networking = true
    ssh_keys = ["${digitalocean_ssh_key.id}"]
    tags = ["k8s-master", "k8s-node", "maestro"]
    user_data = "${file("${var.user_data}")}"
}

