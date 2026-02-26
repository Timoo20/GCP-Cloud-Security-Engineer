resource "google_project_iam_binding" "editor_binding" {
  role = "roles/editor"
  members = ["group:engineering@example.com"]
}

resource "google_compute_security_policy" "default" {
  name = "waf-default"
  rule {
    priority = 1000
    action = "allow"
    match {
      versioned_expr = "SRC_IPS_V1"
      config { src_ip_ranges = ["0.0.0.0/0"] }
    }
  }
}
