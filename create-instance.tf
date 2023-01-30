data "template_file" "linux-metadata" {
template = <<EOF
#cloud-config
runcmd:
- <%=instance.cloudConfig.agentInstall%>
- <%=instance.cloudConfig.finalizeServer%>
EOF
}

resource "google_compute_instance" "default" {
  name         = var.vmName
  machine_type = "f1-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }
  
  metadata_startup_script = data.template_file.linux-metadata.rendered

  network_interface {
    network = "default"
  }

    // Apply the firewall rule to allow external IPs to access this instance
    tags = ["http-server"]
}

resource "google_compute_firewall" "http-server" {
  name    = "default-allow-http-terraform"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  // Allow traffic from everywhere to instances with an http-server tag
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

output "ip" {
  value = "google_compute_instance.default.network_interface.0.network_ip"
}
