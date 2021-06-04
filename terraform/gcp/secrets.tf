# nginx
# create secret
resource "google_secret_manager_secret" "nginx-secret" {
  secret_id = "${var.projectPrefix}-nginx-secret-${var.buildSuffix}"
  labels = {
    label = "nginx"
  }

  replication {
    automatic = true
  }
}
# create secret version
resource "google_secret_manager_secret_version" "nginx-secret" {
  depends_on  = [google_secret_manager_secret.nginx-secret]
  secret      = google_secret_manager_secret.nginx-secret.id
  secret_data = <<-EOF
  {
  "cert":"${var.nginxCert}",
  "key": "${var.nginxKey}",
  "defaultCert": ${jsonencode(tls_self_signed_cert.default.cert_pem)},
  "defaultKey": ${jsonencode(tls_private_key.default.private_key_pem)}
  }
  EOF
}
