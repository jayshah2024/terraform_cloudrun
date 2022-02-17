provider "google" {
  credentials = file("searce-msp-gcp-cbf7a85970dd.json")
  project = "searce-msp-gcp"
  region  = "asia-south1"
  zone    = "asia-south1-a"
}

// Ressource 1: cloud run service running the docker image
// Write the path to the docker image hosted in the google container registry
// To set up this resource with Terraform, the service account key used 
// must have the appropriate permissions.
resource "google_cloud_run_service" "a" {

  // for_each = toset(local.locations)
  // name     = "service-${each.key}"

  count = length(var.names)
  name  = var.names[count.index]
  location = "asia-south1"

   template {
    spec {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}



// Ressource 2: gives to non authenticated users access to the web page
// To set up this resource with Terraform, the service account key used 
// must have the appropriate permissions.

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = ["allUsers"]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  count       = length(var.names)
  service     = google_cloud_run_service.a[count.index].name
  location    = google_cloud_run_service.a[count.index].location
  policy_data = data.google_iam_policy.noauth.policy_data
}



################################
